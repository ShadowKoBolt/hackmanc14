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
    @state = :active
  end

  def stop
    @state = :ready
  end

  def restart
    set_defaults!
    start
  end

  def active?
    state == :active
  end

  def ready?
    state == :ready
  end

  def set_defaults!
    @state = :ready
    @health = 100
  end

  def decrement_towers!
    new_health = (@towers.inject(0) { |res, t| res + t.enemies })
    if new_health <= 0
      @health = 0
    end
  end

  def new_player_from_connection(connection)
    p = Player.new(generate_id, connection)
    players << p
    p
  end

  def find_player(id)
    @players.select { |p| p.id == 0 }
  end

  def find_tower(id)
    @towers.select { |p| p.id == 0 }
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
        game_message("start")
      when "stop"
        game_message("stop")
      end
      render!
    rescue Exception
    end
  end


  def user_message(player, message)
    if message["location"] == 0
      player.location = :base
      player.add_ammo!
    else
      tower = find_tower(message["location"])
      player.location = tower
      if tower
        if player.ammo > 0
          player.remove_ammo! 
          tower.remove_enemy! if tower.enemies > 0
        end
      end
    end
  end

  def game_message(action)
    self.send action
  end

  def remove_player_with_id(id)
    !!(@players.reject! { |item| item.id == id }.nil?)
  end

  def render!
    players.each do |player|
      player.connection.send self.to_json
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
