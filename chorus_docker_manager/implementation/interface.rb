require 'contractual'

module ChorusDockerManager
  class ApiInterface
    include Contractual::Interface

    must :create_container, :username
    must :destroy_container, :username

    must :has_running_container, :username
  end
end