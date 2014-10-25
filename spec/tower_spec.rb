require './app/game.rb'

describe Tower do
  subject { Tower.new(1, 100) }
  specify { subject.to_json.should be == "{\"id\":1,\"enemies\":0}" }
end

