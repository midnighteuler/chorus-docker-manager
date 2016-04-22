require 'httparty'
require_relative 'exceptions'

module ChorusDockerManager
  class Api < ChorusDockerManager::ApiInterface
    def initialize(h)
      @params = h

      @host = h[:host]
      @port = h[:port]
      @timeout = h[:timeout] || 5
    end

    def server_url
      "http://#{@host}" + (@port ? ":#{@port}" : "")
    end

    def has_running_container(user)
      response = HTTParty.get(server_url + '/api', timeout: @timeout)
      @remote_api_version = response["version"]
    rescue Exception => e
      raise ChorusDockerManager::ApiFetchError, e.message
    end
  end
end