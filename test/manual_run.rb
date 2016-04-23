require '../chorus_docker_manager/chorus_docker_manager'

COMMANDER_SERVER_IP='10.0.0.94'
COMMANDER_SERVER_PORT=8000
CHORUS_ADDRESS='http://10.0.0.94:8080'

t = ChorusDockerManager::Api.new({
   :host => COMMANDER_SERVER_IP,
   :port => COMMANDER_SERVER_PORT,
   :chorus_address => CHORUS_ADDRESS,
   :timeout => 5
})

puts t
puts t.server_url
puts "Seeing if 'mike' has a container:"
puts t.has_running_container('1')

puts "Creating a container for mike:"
puts t.create_container('1')

puts "Destroying container:"
puts t.destroy_container('1')

puts "Seeing if 'mike' has a container:"
puts t.has_running_container('1')

#puts "Destroying container for mike:"
#puts t.destroy_container('mike')
#
#puts "Seeing if 'mike' has a container:"
#puts t.has_running_container('mike')