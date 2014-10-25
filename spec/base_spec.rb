require './app/game.rb'

describe Base do
  subject { Base.new(1, 100) }
  specify { subject.to_json.should be == "{\"id\":1,\"health\":100}" }
end

