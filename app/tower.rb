class Tower
  attr_reader :id, :enemies

  def initialize(id, health)
    @id, @health = id, health
  end

  def enemies
    @enemies ||= 0
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
