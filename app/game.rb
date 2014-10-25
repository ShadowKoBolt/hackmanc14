require 'json'
require './app/tower.rb'
require './app/player.rb'
require './app/enemy.rb'

class Game

  attr_reader :towers

  def initialize(*towers)
    @towers = towers
  end

  def players
    @player ||= []
  end

  def enemies
    @player ||= []
  end

  def to_json
    {
      towers:towers.map(&:as_json),
      players:players,
      enemies:enemies
    }.to_json
  end

end
