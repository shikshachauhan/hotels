require "rails_helper"

RSpec.describe RoomDetail, :type => :model do
  describe 'Asscociations' do
    it { should belong_to(:room_type) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:availability) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:date) }
  end

  describe 'Instance Methods' do
    describe '#as_json' do
      let(:room_detail) { RoomDetail.new(availability: 5, price: 5000, date: Date.today) }
      before do
        room_detail.build_room_type(room_type: RoomType::TYPE['Single'])
      end
      it 'should return json of object' do
        expect(room_detail.as_json.to_json).to eq ({
          id: room_detail.id,
          availability: room_detail.availability,
          price: room_detail.price,
          date: room_detail.date.to_date,
          room_type: RoomType::TYPE.key(room_detail.room_type.room_type)
        }.to_json)
      end
    end
  end
end
