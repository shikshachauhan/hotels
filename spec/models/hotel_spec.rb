require "rails_helper"

RSpec.describe Hotel, :type => :model do
  describe 'Asscociations' do
    it { should have_many(:room_types) }
  end
end
