require './app/game.rb'

describe Game do
  let(:tower_1) { double('Tower 1', {as_json:'identifiable_string'}) }
  let(:tower_2) { double('Tower 1', {as_json:'another_identifiable_string'}) }
  subject { Game.new(tower_1, tower_2) }

  describe "to_json" do
    specify { subject.to_json.should be == "{\"health\":100,\"towers\":[\"identifiable_string\",\"another_identifiable_string\"],\"players\":[]}" }
  end

  describe "new_player_from_connection" do
    it "creates and stores a player" do
      connection = double("connection")
      player = subject.new_player_from_connection(connection)
      subject.players.should include(player)
      player.id.should be == 1
    end
  end

  describe "remove_player_with_id" do
    it "creates and stores a player" do
      connection = double("connection")
      player_1 = subject.new_player_from_connection(connection)
      player_2 = subject.new_player_from_connection(connection)
      subject.remove_player_with_id 1
      subject.players.should_not include(player_1)
      subject.players.should include(player_2)
    end
  end
end
