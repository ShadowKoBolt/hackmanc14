require './app/game.rb'

describe Game do
  let(:connection) { double("connection") }
  subject { Player.new(1, connection) }

  describe "to_json" do
    specify { subject.to_json.should be == "{\"id\":1,\"ammo\":0}" }
  end
end
