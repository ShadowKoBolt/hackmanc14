class Player
  attr_reader :id, :ammunition, :connection

  def initialize(id, connection)
    @id, @connection, @ammo = id, connection, 5
  end

  def has_ammo?
    @ammo > 0
  end

  def remove_ammo!
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
      ammo:@ammo
    }
  end

  def to_json
    as_json.to_json
  end

end
