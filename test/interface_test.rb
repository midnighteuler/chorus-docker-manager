gem 'minitest'
require 'minitest/autorun'

require_relative  '../chorus_docker_manager/docker_manager_api_interface'

class TestUsesInterface < Minitest::Test
  class IncompleteAPI < ChorusDockerManager::ApiInterface; end

  def test_interface_requires_methods
    c = IncompleteAPI.new

    assert_raises Contractual::Interface::MethodNotImplementedError do
      c.has_running_container('some_user')
    end
  end
end