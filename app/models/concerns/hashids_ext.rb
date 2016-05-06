module HashidsExt
  extend ActiveSupport::Concern

  def hashids
    self.class.hashids
  end

  def to_param
    id && hashids.encode(id)
  end

  module FinderMethods
    def find(ids = nil, &block)
      return detect(&block) if block.present?

      decoded_ids = Array(ids).map { |id| id.is_a?(String) ? hashids.decode(id) : id }.flatten
      raise 'Decode error' if Array(ids).size != decoded_ids.size
      res = where(id: decoded_ids).all
      if ids.is_a?(Array)
        if res.size != decoded_ids.size
          raise_record_not_found_exception! decoded_ids, res.size, decoded_ids.size
        end
        res
      else
        if res.empty?
          raise_record_not_found_exception! decoded_ids[0], res.size, decoded_ids.size
        end
        res[0]
      end
    end

    private

    def raise_record_not_found_exception!(ids, result_size, expected_size)
      if Array(ids).size == 1
        error = "Couldn't find #{name} with '#{primary_key}'=#{ids}"
      else
        error = "Couldn't find all #{name.pluralize} with '#{primary_key}': "
        error << "(#{ids.join(', ')}) (found #{result_size} results, but was looking for #{expected_size})"
      end

      raise ActiveRecord::RecordNotFound, error
    end
  end

  module ClassMethods
    include FinderMethods

    def has_many(*args, &block) # rubocop:disable Style/PredicateName
      options = args.extract_options!
      options[:extend] = (options[:extend] || []).concat([FinderMethods])
      super(*args, options, &block)
    end

    def hashids
      Hashids.new("#{base_class.name} #{Settings.application.misc.hashids_secret}", 8)
    end

    def relation
      r = super
      r.extend FinderMethods
      r
    end
  end
end
