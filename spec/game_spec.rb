require './app/game.rb'

describe Game do
  let(:tower_1) { double('Tower 1', {as_json:'identifiable_string'}) }
  let(:tower_2) { double('Tower 1', {as_json:'another_identifiable_string'}) }
  subject { Game.new(tower_1, tower_2) }
  specify { subject.to_json.should be == "{\"towers\":[\"identifiable_string\",\"another_identifiable_string\"],\"players\":[],\"enemies\":[]}" }
end
