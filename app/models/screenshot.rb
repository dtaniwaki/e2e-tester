class Screenshot < ApplicationRecord
  belongs_to :test_step_execution, inverse_of: :screenshot
  belongs_to :test_step, class_name: 'TestStep::Screenshot', inverse_of: :screenshots

  has_attached_file :image, path: ':root/screenshots/:short_obfuscate_id_hash/:full_obfuscate_id-:style.:extension',
                            default_url: 'data:image/gif;base64,R0lGODlhAQABAIAAAMLCwgAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==',
                            styles: { thumb: '200x200#' },
                            hash_secret: '7b1ff7f2c575f86db0264dfc9b7edff1e8bd3a59c07cf8df22f2f01153538661'

  validates :image, attachment_content_type: { content_type: %r{\Aimage\/.*\Z} }
end
