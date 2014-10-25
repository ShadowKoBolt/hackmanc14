class Base
  attr_reader :id, :health

  def initialize(id, health)
    @id, @health = id, health
  end

  def as_json
    {
      id:id,
      health:health
    }
  end

  def to_json
    as_json.to_json
  end
end
