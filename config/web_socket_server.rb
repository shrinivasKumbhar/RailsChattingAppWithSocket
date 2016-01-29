require 'em-websocket'
require 'json'
i = 1;
EM.run {
@clients = Hash.new { |k,v| k[v] = [] }
  EM::WebSocket.start(:host => "0.0.0.0", :port => 8081) do |ws|
    ws.onopen { |handshake|
      puts "WebSocket connection open"

      # Access properties on the EM::WebSocket::Handshake object, e.g.
      # path, query_string, origin, headers

      # Publish message to the client
      ws.send "Hello Client, you connected to #{handshake.query}"
    @clients[i] << ws
      i += 1
    path = handshake.path
        query_str = handshake.query
        origin = handshake.origin
puts "#{path} query:   #{query_str}    #{origin}"
    }

    ws.onclose { puts "Connection closed" }

    ws.onmessage { |msg|
      json_msg = JSON.parse(msg)
      puts "Recieved message: #{json_msg}"
      #ws.send "Message from  : #{json_msg["sender_id"]} : #{json_msg}"
      puts "#{@clients[1][0]}  :::::::::::  #{json_msg['receiver_id']}"
      #@clients[json_msg['receiver_id'].to_s].each do |client|
      #  puts "#{client}"
      #  client.send(msg)

      @clients[1][0].send(msg);
      #end
    }
  end
}