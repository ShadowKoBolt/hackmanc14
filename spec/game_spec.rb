require './app/game.rb'

describe Game do
  subject { Game.new('identifiable_string', 'another_identifiable_string') }
  specify { subject.to_json.should be == "{\"bases\":[\"identifiable_string\",\"another_identifiable_string\"],\"players\":[],\"enemies\":[]}" }
end
