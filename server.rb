tls_options = {
  :private_key_file => "/etc/apache2/ssl/llamadigital.net.key", 
  :cert_chain_file => "/etc/apache2/ssl/llamadigital.net.crt"
}

EM.run {

  @current_game = Game.new Tower.new(1,100), Tower.new(2,100), Tower.new(3,100)

  wave_timer = EventMachine::PeriodicTimer.new 20, Proc.new {
    if @current_game.players.length > 0
      old_health = @current_game.health
      tower = @current_game.towers.sample
      puts "new wave attacking tower: #{tower.id}"
      tower.new_wave!(5)
      @current_game.render! if old_health != @current_game.health
    end
  }

  attack_timer = EventMachine::PeriodicTimer.new 5, Proc.new {
    if @current_game.players.length > 0
      @current_game.decrement_towers! 
      @current_game.render!
    end
  }

  EM::WebSocket.run(
    :host => "0.0.0.0", 
    :port => 8080, 
    :secure => !ENV['ENVIRONMENT']=='development', 
    :tls_options => ENV['ENVIRONMENT'] == 'development' ? {} : tls_options ) do |ws|

      player_id = nil

      ws.onopen do |handshake|
        puts "WebSocket connection open"
        player_id = @current_game.new_player_from_connection(ws).id
        ws.send(@current_game.to_json)
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
