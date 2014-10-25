require 'rubygems'
require 'bundler/setup'
Bundler.require

require './app/game.rb'

EM.run {

  @current_game = Game.new Tower.new(1,100), Tower.new(2,100), Tower.new(3,100)

  # EventMachine.add_timer 5, proc { puts "Executing timer event: #{Time.now}" }
  #   EventMachine.add_timer(10) { puts "Executing timer event: #{Time.now}" }

  EM::WebSocket.run(:host => "0.0.0.0", :port => 8080) do |ws|

    player_id = nil

    ws.onopen do |handshake|
      puts "WebSocket connection open"
      player_id = @current_game.new_payer_from_connection(ws).id
      ws.send {success:true}.to_json 
    end

    ws.onclose do 
      puts "Connection closed" 
      ws.send "Closed."
      @current_game.remove_player_with_id player_id
    end

    ws.onmessage do |msg|
      @current_game.receive_message(player_id, msg)
    end
  end

  puts "Server running"
}
