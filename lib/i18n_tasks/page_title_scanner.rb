module I18nTasks
  class PageTitleScanner < ::I18n::Tasks::Scanners::FileScanner
    include I18n::Tasks::Scanners::OccurrenceFromPosition

    protected

    def scan_file(path)
      return [] unless path =~ %r{(views)/(.+/[^_/][^./]+)[^/]+$}
      relative_path = "#{Regexp.last_match(1)}/#{Regexp.last_match(2)}"
      return [] if Regexp.last_match(2).start_with?('layouts')
      return [] if Regexp.last_match(2) =~ /[_]?mailer\b/
      results = []
      File.open(path) do |f|
        text = f.read
        unless text =~ /t\(['"]\.title['"]\)/
          results << ["#{relative_path.tr('/', '.')}.title", occurrence_from_position(path, text, 0)]
        end
      end
      results
    end
  end
end
