require 'rubygems'
require 'bundler/setup'
Bundler.require

require './app/game.rb'

EM.run {

  current_game = Game.new Tower.new(1,100), Tower.new(2,100), Tower.new(3,100)

  EM::WebSocket.run(:host => "0.0.0.0", :port => 8080) do |ws|

    ws.onopen do |handshake|
      puts "WebSocket connection open"

      # Access properties on the EM::WebSocket::Handshake
      # object, e.g. path, query_string, origin, headers

      # Publish message to the client
      ws.send current_game.to_json 
    end

    ws.onclose do 
      puts "Connection closed" 
    end

    ws.onmessage do |msg|
      puts "Recieved message:
      #{msg}"
      ws.send "Pong:
      #{msg}"
    end
  end
}
