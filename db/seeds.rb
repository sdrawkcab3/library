# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# User.create(email: "rick@example.com", password: "password", password_confirmation: "password" )

10.times do |x|
    Review.create(title: "Review #{x+1}", body: "Body #{x+1} Reviews go here", stars: 3, user_id: User.first.id, book_id: Books.first.id)
end