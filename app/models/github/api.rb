# encoding: utf-8
require 'faraday'
require 'faraday_middleware'

module Github
  GITHUB_API_HOST = 'https://api.github.com'

  class API
    def get(path = nil)
      response = connection.get(path)
      if response.success?
        response.body
      else
        nil
      end
    end

    def member_of(org, username)
      public_membership = "/orgs/#{org}/public_members/#{username}"
      response = connection.get(public_membership)
      response.success?
    end

    protected

    def connection
      @connection ||= Faraday.new(url: GITHUB_API_HOST) do |conn|
        conn.request :json

        conn.response :json, :content_type => /\bjson|javascript$/
        conn.response :logger if defined?(Rails) && !Rails.env.test?

        conn.use :instrumentation if defined?(ActiveSupport) && defined?(ActiveSupport::Notifications)
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
