require 'httparty'
#require 'uri'
require_relative 'interface'
require_relative 'exceptions'

module ChorusDockerManager
  class Api < ChorusDockerManager::ApiInterface
    def initialize(h)
      @params = h

      @host = h[:host]
      @port = h[:port]
      @timeout = h[:timeout] || 5

      @chorus_address = h[:chorus_address]
      @docker_image_name = h[:docker_image_name] || 'alpinedata/chorus_commander'
      @docker_command = h[:docker_command] || 'jupyter notebook --config=chorus_notebook_config.py'

      @additional_launch_params = h[:additional_launch_params] || {}
    end

    def server_url
      "http://#{@host}" + (@port ? ":#{@port}" : "")
    end

    def has_running_container(username)
      response = HTTParty.get("#{server_url}/api/v1.0/get_container_for_user?username=#{username}", { :timeout => @timeout })

      return response
    rescue Exception => e
      raise ChorusDockerManager::ApiFetchError, e.message
    end

    def create_container(username)
      response = HTTParty.post("#{server_url}/api/v1.0/run_notebook_in_docker", {
          :body => {
              :username => username,
              :chorus_address => @chorus_address,
              :command => @docker_command,
              :image_name => @docker_image_name
          }.merge(@additional_launch_params),
          :timeout => @timeout
      })

      return response
    rescue Exception => e
      raise ChorusDockerManager::ApiFetchError, e.message
    end

    def destroy_container(username)
      response = HTTParty.post("#{server_url}/api/v1.0/stop_notebook_docker_container", {
          :body => {
              :username => username
          },
          :timeout => @timeout
      })

      return response
    rescue Exception => e
      raise ChorusDockerManager::ApiFetchError, e.message
    end
  end
end