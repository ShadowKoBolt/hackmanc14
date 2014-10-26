class GameActor
  def as_json
    raise NotImplementedError
  end

  def to_json
    as_json.to_json
  end
end
