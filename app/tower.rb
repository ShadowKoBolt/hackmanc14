class Tower
  attr_reader :id, :enemies

  def initialize(id, health)
    @id, @health, @enemies = id, health, 0
  end

  def new_wave!(n=5)
    @enemies += n
  end

  def remove_enemy!
    puts "enemy killed!"
    @enemies = [(@enemies - 1), 0].max
  end

  def as_json
    {
      id:id,
      enemies:enemies
    }
  end

  def to_json
    as_json.to_json
  end
end
