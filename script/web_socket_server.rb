require 'em-websocket'
require 'json'

EM.run {
@clients = Hash.new { |k,v| k[v] = [] }
  #start new websocket on specific host and port number
  EM::WebSocket.start(:host => "0.0.0.0", :port => 8086) do |ws|
    ws.onopen { |handshake|
      puts "WebSocket connection open"

      # Access properties on the EM::WebSocket::Handshake object, e.g.
      # path, query_string, origin, headers

      # Publish message to the client


    #path = handshake.path
        query_str = handshake.query
      #ws.send "Hello Client, you connected to #{query_str["user_id"]}"
       # origin = handshake.origin

      #store the connected user id in the @clients hash with 'user_id' as key and ws object as value
      @clients[query_str["user_id"].to_s] << ws
      puts "user_id:   #{query_str["user_id"]}"
    }
    ws.onclose {
      puts "Connection closed"
    }
    ws.onmessage{|msg|
      json_msg = JSON.parse(msg)
      #puts "Recieved message: #{json_msg}"
      #ws.send "Message from  : #{json_msg["sender_id"]} : #{json_msg}"
      #puts "#{@clients[1][0]}  :::::::::::  #{json_msg['receiver_id']}"

      if json_msg["category"] == "SEND"
        #get the receivers ws object from the stored has and send message to that user only
        @clients[json_msg['receiver_id'].to_s].each do |client|
          puts " client : #{client}"
          client.send(msg)
        end
      elsif json_msg["category"] == "LOGOUT"    #in user logout his socket connection will be closed
        @clients.delete(json_msg['user_id'].to_s)
      end
      #ws.send "server msg #{msg}"
    }
  end
}