# i18n-tasks is not flexible enough to replace keys
module Patch
  module I18nTasks
    def replace_key
      return unless defined?(I18n::Tasks)
      require 'i18n/tasks/scanners/ruby_ast_scanner'
      require 'i18n/tasks/scanners/pattern_with_scope_scanner'

      I18n::Tasks::Scanners::RubyAstScanner.__send__(:prepend, Module.new do
        def absolute_key(key, path, roots: config[:relative_roots], calling_method: nil)
          s = super
          case path
          when /controllers/
            s = s.gsub(/^shared\./, 'controllers.shared.')
          end
          s
        end
      end)
      I18n::Tasks::Scanners::PatternWithScopeScanner.__send__(:prepend, Module.new do
        def absolute_key(key, path, roots: config[:relative_roots], calling_method: nil)
          s = super
          case path
          when /views/
            s = s.gsub(/^shared\./, 'views.shared.')
            s = s.gsub(/^layout\./, 'views.layout.')
          end
          s
        end
      end)
    end
    module_function :replace_key
  end
end
