require '../chorus_docker_manager/chorus_docker_manager'

COMMANDER_SERVER_IP='10.0.0.146'
COMMANDER_SERVER_PORT=8088

t = ChorusDockerManager::Api.new({
   :host => COMMANDER_SERVER_IP,
   :port => COMMANDER_SERVER_PORT,
   :timeout => 5
})

puts t
puts t.server_url
puts t.has_running_container('mike')