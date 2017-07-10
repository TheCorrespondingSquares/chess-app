# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Game.delete_all
User.delete_all
Piece.delete_all

default_user = User.new(
  email: "default@gmail.com",
  nickname: "John Doe",
  password: "password",
  password_confirmation: "password"
)
# user.skip_confirmation!
default_user.save!

30.times do
  user = User.new(
    email: Faker::Internet.email,
    nickname: Faker::Internet.user_name,
    password: "password",
    password_confirmation: "password"
  )
  # user.skip_confirmation!
  user.save!
end
