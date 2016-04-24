require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.default_cassette_options = {
    record: :once,
    match_requests_on: [:method, :host, :path, :query, :body, :headers]
  }
  c.before_record do |interaction|
    interaction.request.uri.sub!(%r|://[^@]+@|, '://username:password@')
  end
end
