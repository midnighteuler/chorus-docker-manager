COMMANDER_SERVER_IP='10.0.0.94'
COMMANDER_SERVER_PORT=8000

gem 'minitest'
require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'
require '../chorus_docker_manager/docker_manager_api_interface.rb'
require '../chorus_docker_manager/docker_manager_api.rb'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
end

describe ChorusDockerManager::Api do
  describe "creating a docker container for a given user" do
    before do
      @valid_params = {
        :host => COMMANDER_SERVER_IP,
        :port => COMMANDER_SERVER_PORT
      }
      @user_not_running = 'not_running'
      @user_running = 'running'

      @api = ChorusDockerManager::Api.new(@valid_params)
    end

    it "respects timeout" do
      stub_request(:get, "#{@api.server_url}/api/v1.0/get_container_for_user?username=#{@user_not_running}").to_timeout

      err = assert_raises ChorusDockerManager::ApiFetchError do
        @api.has_running_container(@user_not_running)
      end

      assert_match /execution expired/, err.message
    end

    it "sends a GET request server to determine if a container is running" do
      VCR.use_cassette('has_container_not_running') do
        container_running_check = @api.has_running_container(@user_not_running)

        container_running_check.has_key?('running')
        container_running_check['running'].must_equal false
        container_running_check.code.must_equal 200
      end
    end

    it "sends a POST request server to launch a container" do
      VCR.use_cassette('launch_container') do
        if @api.has_running_container(@user_running)['running'] == true
          @api.destroy_container(@user_running)
        end

        container_launch = @api.create_container(@user_running)

        container_launch.has_key?('container_name')
        container_launch.has_key?('port')
        container_launch.code.must_equal 201
      end
    end

    it "sends a POST request server to destroy a container" do
      VCR.use_cassette('destroy_container') do
        if @api.has_running_container(@user_running)['running'] == false
          @api.create_container(@user_running)
        end

        container_destroy = @api.destroy_container(@user_running)

        container_destroy.has_key?('container_name')
        container_destroy.code.must_equal 202
      end
    end
  end
end
