require 'json'
require './app/tower.rb'
require './app/player.rb'
require './app/enemy.rb'

class Game

  attr_reader :towers

  def initialize(*towers)
    @towers = towers
  end

  def health
    @health ||= 100
  end

  def new_player_from_connection(connection)
    p = Player.new(generate_id, connection)
    players << p
    p
  end

  def remove_player_with_id(id)
    !!(@players.reject! { |item| item.id == id }.nil?)
  end

  def render!
    puts 'render called'
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
