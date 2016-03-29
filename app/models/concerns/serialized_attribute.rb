module SerializedAttribute
  extend ActiveSupport::Concern

  included do
    serialize :data, JSON
  end

  module ClassMethods
    def serialized_attribute(*names)
      names.each do |name|
        name = name.to_s
        define_method name do
          self.data ||= {}
          self.data[name]
        end
        define_method "#{name}=" do |value|
          self.data ||= {}
          self.data[name] = value
        end
      end
    end
  end
end
