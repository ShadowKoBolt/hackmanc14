require 'json'
require './app/base.rb'
require './app/player.rb'
require './app/enemy.rb'

class Game

  attr_reader :bases

  def initialize(*bases)
    @bases = bases
  end

  def players
    @player ||= []
  end

  def enemies
    @player ||= []
  end

  def to_json
    {
      bases:bases,
      players:players,
      enemies:enemies
    }.to_json
  end

end
