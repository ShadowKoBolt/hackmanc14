class Base
  attr_reader :id, :health

  def initialize(id, health)
    @id, @health = id, health
  end

  def to_json
    {
      id:id,
      health:health
    }.to_json
  end
end
