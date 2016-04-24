module Refinements
  module ReplaceVariables
    refine String do
      def replace_variables(variables)
        s = dup
        variables.each do |name, value|
          s = s.gsub(/{#{name}}/, value.to_s)
        end
        s
      end
    end
  end
end
