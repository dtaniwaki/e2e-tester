Paperclip.options[:log] = true

Paperclip.interpolates :root do |_attachment, _style|
  s = Settings.storage.root.to_s
  s += '/' if s[-1] != '/'
  s
end

Paperclip.interpolates :full_obfuscate_id do |attachment, _style|
  # => '9876543210' (10 digit)
  attachment.instance.to_param
end

Paperclip.interpolates :short_obfuscate_id_hash do |attachment, _style|
  # => '1ab'
  Digest::MD5.hexdigest(attachment.instance.to_param)[0...3]
end

Paperclip::Attachment.default_options.update(Settings.storage.to_hash.reverse_merge(
                                               storage: :fog,
                                               fog_public: true,
                                               path: ':url'
))
