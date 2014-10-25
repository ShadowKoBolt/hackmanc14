class Player
  attr_reader :id, :ammunition, :connection

  def initialize(id, connection)
    @id, @connection = id, connection
  end

  def health
    @health ||= 100
  end
end
