class RoomDetail < ActiveRecord::Base
  belongs_to :room_type

  validates :availability, :price, :date, presence: true

  def as_json
    {
      id: id,
      availability: availability,
      price: price,
      date: date.to_date,
      room_type: RoomType::TYPE.key(room_type.room_type)
    }
  end
end
