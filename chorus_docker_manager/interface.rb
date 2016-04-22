require 'contractual'

module ChorusDockerManager
  class ApiInterface
    include Contractual::Interface

    must :create_container, :user
    must :destroy_container, :user

    must :has_running_container, :user
  end
end