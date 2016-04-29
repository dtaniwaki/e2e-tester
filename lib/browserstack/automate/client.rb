# frozen_string_literal: true
require 'faraday'
require 'yajl'

module Browserstack
  module Automate
    class Client
      END_POINT = 'https://www.browserstack.com/automate'

      def initialize(config)
        config = Hash[config.map { |k, v| [k.to_sym, v] }]
        username = config[:username]
        password = config[:password]
        @connection = Faraday.new(END_POINT, ssl: { verify: false }) do |conn|
          conn.request :url_encoded
          conn.use Faraday::Request::BasicAuthentication, username, password
          conn.adapter Faraday.default_adapter
        end
        @parser = Yajl::Parser.new(symbolize_keys: true)
      end

      def browsers
        response = @connection.get('browsers.json')
        @parser.parse(response.body) || []
      end
    end
  end
end
