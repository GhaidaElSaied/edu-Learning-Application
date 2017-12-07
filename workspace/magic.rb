require 'em-websocket'
require 'json'

# A MULTICAST SERVER 
def valid_json?(json)
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
end

EventMachine.run do
  @channel = EM::Channel.new

  @port = 8081
  @ip = "0.0.0.0"

  EM::WebSocket.start(:host => @ip, :port => @port) do |ws|
    ws.onopen {
      sid = @channel.subscribe { |msg| ws.send msg }
      @channel.push({:identity=> "MagicServer", :message=> "Device ##{sid} connected to the Source of Magic"}.to_json)
      
      ws.onmessage { |msg|
      if valid_json?(msg)
        @channel.push msg
      end
        #@channel.push "#{msg}"
      }
      ws.onclose {
        @channel.unsubscribe(sid)
      }
    }
  end

  puts "Server started at", "#{@ip}:#{@port}"
end
