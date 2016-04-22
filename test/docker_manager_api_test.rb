COMMANDER_SERVER_IP='10.0.0.146'
COMMANDER_SERVER_PORT=8088

gem 'minitest'
require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'
require '../chorus_docker_manager/interface.rb'
require '../chorus_docker_manager/api.rb'

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
      stub_request(:get, @api.server_url + '/api').to_timeout

      err = assert_raises ChorusDockerManager::ApiFetchError do
        @api.has_running_container(@user_not_running)
      end

      assert_match /execution expired/, err.message
    end

    it "sends a GET request server to determine if a container is running" do
      VCR.use_cassette('has_container_not_running') do

        container_running_check = @api.has_running_container(@user_not_running)

        container_running_check.must_equal false
      end
    end
  end
end
