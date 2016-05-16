class PageSource < ApplicationRecord
  belongs_to :test_step_execution, inverse_of: :page_source
  belongs_to :test_step, class_name: 'TestStep::PageSource', inverse_of: :page_sources

  has_attached_file :source, path: ':root/page_sources/:short_obfuscate_id_hash/:full_obfuscate_id.html.txt',
                             hash_secret: '6d14270fa22e07789913b245b70c1f801f8201e8327a6420ae5dc652bd2ccc5b'

  validates :source, attachment_content_type: { content_type: %r{\Atext\/.*\Z} }

  def contents
    ::Paperclip.io_adapters.for(source).read
  end
end
