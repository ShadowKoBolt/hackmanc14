tls_options = {
  :private_key_file => "/etc/apache2/ssl/llamadigital.net.key", 
  :cert_chain_file => "/etc/apache2/ssl/llamadigital.net.crt"
}

EM.run {

  @game = Game.new Tower.new(2, 100), Tower.new(3, 100), Tower.new(4, 100)

  EventMachine::PeriodicTimer.new 20, Proc.new {
    puts "game state is #{@game.state} with #{@game.players.length} players"
    if @game.active? && @game.players.length > 0
      puts "enemies advancing"
      old_health = @game.health
      tower = @game.towers.sample
      puts "new wave attacking tower: #{tower.id}"
      tower.new_wave!(rand(7))
      @game.broadcast_message("new wave attacking tower: #{tower.id}")
      if old_health != @game.health
        @game.render!
      end
    end
  }

  EventMachine::PeriodicTimer.new 5, Proc.new {
    puts "game state is #{@game.state} with #{@game.players.length} players"
    if @game.active? && @game.players.length > 0
      puts "enemies attacking"
      @game.decrement_towers! 
      @game.render!
    end
  }

  EM::WebSocket.run(
    :host => "0.0.0.0", 
    :port => 8080, 
    :secure => !(ENV['ENVIRONMENT'] == 'development'), 
    :tls_options => ENV['ENVIRONMENT'] == 'development' ? {} : tls_options ) do |ws|

      player = nil

      ws.onopen do |handshake|
        puts "WebSocket connection open"
        player = @game.new_player_from_connection(ws)
        ws.send({config:player.as_json}.to_json)
      end

      ws.onclose do 
        puts "Connection closed" 
        ws.send "Closed."
        @game.remove_player_with_id player.id
      end

      ws.onmessage do |msg|
        puts "Raw message received from user: #{player.id}"
        puts msg
        @game.receive_message(player.id, msg)
      end

      ws.onerror do  |error|
        puts "websocket error: #{error.inspect}: #{error.message}"
      end
    end

    puts "Server started: Lets Dance!!!!"
}
