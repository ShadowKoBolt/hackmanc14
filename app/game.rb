require 'json'
require './app/tower.rb'
require './app/player.rb'
require './app/enemy.rb'

class Game

  attr_reader :towers, :health

  def initialize(*towers)
    @health = 100
    @towers = towers
  end

  def decrement_towers!
    @health -= (@towers.inject(0) { |res, t| res + t.enemies })
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
      if message["location"] == 0
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
      render!
    rescue Exception => e
    end
  end

  def remove_player_with_id(id)
    !!(@players.reject! { |item| item.id == id }.nil?)
  end

  def render!
    players.each do |player|
      player.connection.send self.to_json
    end
  end

  def to_json
    {
      health:health,
      towers:towers.map(&:as_json),
      players:players.map(&:as_json)
    }.to_json
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
