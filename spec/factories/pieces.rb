FactoryGirl.define do
  # A default queen piece, due to her range of movement (useful for tests)
  factory :piece do
    name "Queen"
    # color "black"
    x_pos 1
    y_pos 1
    # game_id 1
    captured false
  end
end
