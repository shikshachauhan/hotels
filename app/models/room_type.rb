class RoomType < ActiveRecord::Base
  belongs_to :hotel
  has_many :room_details

  TYPE = {
    'Single' => 1,
    'Double' => 2
  }

  validates :room_type, inclusion: { in: TYPE.values }
end
