require 'json'
require './app/tower.rb'
require './app/player.rb'
require './app/enemy.rb'

class Game

  attr_reader :towers, :health, :state

  def initialize(*towers)
    set_defaults!
    @towers = towers
  end

  def start
    puts "starting game"
    @state = :active
  end

  def stop
    puts "stopping game"
    @state = :ready
  end

  def restart
    puts "restarting game"
    set_defaults!
    start
  end

  def active?
    state == :active
  end

  def game_over?
    state == :game_over
  end
  
  def game_over!
    @state = :game_over
  end

  def ready?
    state == :ready
  end

  def set_defaults!
    @state = :ready
    @health = 100
    if @towers
      @towers.each do |tower|
        tower.reset!
      end
    end
  end

  def decrement_towers!
    damage = (@towers.inject(0) { |res, t| res + t.enemies })
    @health = [(@health - damage), 0].max
  end

  def new_player_from_connection(connection)
    p = Player.new(generate_id, connection)
    players << p
    p
  end

  def find_player(id)
    @players.select { |p| p.id == id }.first
  end

  def find_tower(id)
    @towers.select { |p| p.id == id }.first
  end

  def receive_message(player_id, message)
    player = find_player(player_id)
    begin
      message = JSON.parse(message)
      case message["action"]
      when "user"
        user_message(player, message)
      when "start"
        game_message("start")
      when "restart"
        game_message("restart")
      when "stop"
        game_message("stop")
      end
      render!
    rescue Exception
    end
  end


  def user_message(player, message)
    puts "message received from user: #{player.id}"
    if message["location"] == 1
      # player.location = :base
      player.add_ammo!
    else
      tower = find_tower(message["location"])
      puts "TOWER: #{tower.id}"
      # player.location = tower
      if tower
        if player.has_ammo?
          player.remove_ammo! 
          tower.remove_enemy! if tower.enemies > 0
        end
      end
    end
    puts "message processed from user: #{player.id}"
    render!
  end

  def game_message(action)
    self.send action
    render!
  end

  def remove_player_with_id(id)
    !!(@players.delete_if { |item| item.id == id }.nil?)
  end

  def render!
    players.each do |player|
      hash = player.connection.send self.as_json
      hash[:me] = player.as_json
      player.connection.send hash.to_json
    end
  end

  def as_json
    {
      state:state,
      health:health,
      towers:towers.map(&:as_json),
      players:players.map(&:as_json)
    }
  end

  def to_json
    as_json.to_json
  end

  def players
    @players ||= []
  end

  private

  def generate_id
    @last_id ||= 0
    @last_id += 1
  end

end
