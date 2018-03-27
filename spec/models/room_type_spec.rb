require "rails_helper"

RSpec.describe RoomType, :type => :model do
  describe 'Asscociations' do
    it { should have_many(:room_details) }
    it { should belong_to(:hotel) }
  end

  describe 'Validations' do
    it do
      should validate_inclusion_of(:room_type).
        in_array(RoomType::TYPE.values)
    end
  end

  describe 'Constants' do
    it 'TYPE should have key Single' do
      expect(RoomType::TYPE['Single']).to be_truthy
    end
    it 'TYPE should have key Double' do
      expect(RoomType::TYPE['Double']).to be_truthy
    end
  end
end
