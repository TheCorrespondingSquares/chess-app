FactoryGirl.define do
  # A default queen piece, due to her range of movement (useful for tests)
  factory :piece do
    captured false
  end

  factory :king, class: King do
    name "King"
    captured false
  end

  factory :queen, class: Queen do
    name "Queen"
    captured false
  end

  factory :bishop, class: Bishop do
    name "Bishop"
    captured false
  end

  factory :rook, class: Rook do
    name "Rook"
    captured false
  end

  factory :knight, class: Knight do
    name "Knight"
    captured false
  end

  factory :pawn, class: Pawn do
    name "Pawn"
    captured false
  end

end
