FactoryGirl.define do
  # A default queen piece, due to her range of movement (useful for tests)
  factory :piece do
    name "queen"
    color "black"
    x_pos 0
    y_pos 0
    game_id 1
    captured false
  end
end
