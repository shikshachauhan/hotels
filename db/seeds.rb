# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

hotel = Hotel.create(name: 'The Hotel')

single_room = hotel.room_types.create(room_type: RoomType::TYPE['Single'])
double_room = hotel.room_types.create(room_type: RoomType::TYPE['Double'])

Date.new(2019, 01, 01).upto(Date.new(2019, 12, 31)) do |date|
  single_room.room_details.create({ availability: 5, price: 5000, date: date })
  double_room.room_details.create({ availability: 5, price: 10000, date: date })
end
