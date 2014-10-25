class Player
  attr_reader :id, :ammunition, :connection

  def initialize(id, connection)
    @id, @connection = id, connection
  end

  def as_json
    {
      id:id,
      ammo:0
    }
  end

  def to_json
    as_json.to_json
  end

end
