class RoomDetail < ActiveRecord::Base
  belongs_to :room_type

  # this invalidates the object if availability, price or date is absent and stops the record saving to DB on application level
  validates :availability, :price, :date, presence: true

  # ORM return acctive record object and creates the desired json. This is called from controller
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
