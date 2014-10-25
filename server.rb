tls_options = {
  :private_key_file => "/etc/apache2/ssl/llamadigital.net.key", 
  :cert_chain_file => "/etc/apache2/ssl/llamadigital.net.crt"
}

EM.run {

  @game = Game.new Tower.new(2, 100), Tower.new(3, 100), Tower.new(4, 100)

  EventMachine::PeriodicTimer.new 20, Proc.new {
    if @game.active? && @game.players.length > 2
      old_health = @game.health
      tower = @game.towers.sample
      puts "new wave attacking tower: #{tower.id}"
      tower.new_wave!(5)
      @game.render! if old_health != @game.health
    end
  }

  EventMachine::PeriodicTimer.new 5, Proc.new {
    if @game.active? && @game.players.length > 0
      @game.decrement_towers! 
      @game.render!
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
        player_id = @game.new_player_from_connection(ws).id
        ws.send(@game.to_json)
      end

      ws.onclose do 
        puts "Connection closed" 
        ws.send "Closed."
        @game.remove_player_with_id player_id
      end

      ws.onmessage do |msg|
        @game.receive_message(player_id, msg)
      end
    end

    puts "Server started: Lets Dance!!!!"
}
