class Player < GameActor
  attr_reader :id, :ammo, :connection, :score

  def initialize(id, connection)
    @id, @connection, @ammo, @score= id, connection, 5, 0
  end

  def has_ammo?
    @ammo > 0
  end

  def remove_ammo!(target_hit=false)
    @score += 1 if targer_hit
    if @ammo > 0
      @ammo -= 1
    end
  end

  def add_ammo!
    if @ammo < 5
      @ammo += 1
    end
  end

  def as_json
    {
      id:id,
      score:score,
      ammo:ammo
    }
  end

end
