require "rails_helper"

RSpec.describe RoomDetailsController, :type => :controller do
  before(:all) do
    @hotel = Hotel.create(name: 'The Hotel')

    @single_room = @hotel.room_types.create(room_type: RoomType::TYPE['Single'])
    @double_room = @hotel.room_types.create(room_type: RoomType::TYPE['Double'])

    Date.new(2019, 01, 01).upto(Date.new(2019, 01, 10)) do |date|
      @single_room.room_details.create({ availability: 5, price: 5000, date: date })
      @double_room.room_details.create({ availability: 5, price: 10000, date: date })
    end
  end

  describe '#index' do
    context 'When hotel loads Successfully' do
      it 'return details according to the input params' do
        get :index, params: {hotel_name: 'The Hotel', start_date: '2019-01-01', end_date: '2019-01-02'}
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)['data'].to_json).to eq(RoomDetail.where(room_type_id: [@single_room.id, @double_room.id], date: [Date.parse('2019-01-01'), Date.parse('2019-01-02')]).map(&:as_json).to_json)
        expect(assigns(:start_date)).to eq Date.parse('2019-01-01')
        expect(assigns(:end_date)).to eq Date.parse('2019-01-02')
        1
      end
    end
    context 'when hotel is not present' do
      it do
        get :index, params: { hotel_name: 'X Hotel' }
        expect(JSON.parse(response.body)["message"]).to eq "Not Found"
        expect(response.status).to eq 404
      end
    end
  end

  describe '#update' do
    context 'when room details is present' do
      it 'updates the details' do
        room_detail = RoomDetail.order(:id).last
        put :update, params: { id: room_detail.id, price: room_detail.price + 1, availability: room_detail.availability + 1 }
        expect(response.status).to eq 200
        updated_detail = RoomDetail.find(room_detail.id)
        expect(updated_detail.price).to eq room_detail.price + 1
        expect(updated_detail.availability).to eq room_detail.availability + 1
      end
    end
    context 'when room detail is not present' do
      it do
        put :update, params: { id: RoomDetail.order(:id).last.id + 1 }
        expect(JSON.parse(response.body)["message"]).to eq "Not Found"
        expect(response.status).to eq 404
      end
    end
  end

  describe '#update_bulk' do
    context 'When input is valid' do
      context 'when hotel is present' do
        it do
          room_detail = @single_room.room_details.where(date: Date.parse('2019-01-01')).first
          put :update_bulk, params: { hotel_name: 'The Hotel', from_date: '2019-01-01', to_date: '2019-01-10', price: 9000, availability: 4, room_type: 'Single' }
          expect(JSON.parse(response.body)["message"]).to eq "Update Successful"
          expect(response.status).to eq 200
          updated_detail = RoomDetail.find_by_id(room_detail.id)
          expect(updated_detail.price).to eq 9000
          expect(updated_detail.availability).to eq 4
        end
      end
      context 'when hotel is not present' do
        it do
          put :update_bulk, params: { hotel_name: 'X Hotel', from_date: '2019-01-01', to_date: '2019-01-10', price: 5000, availability: 4, room_type: 'Single' }
          expect(JSON.parse(response.body)["message"]).to eq "Not Found"
          expect(response.status).to eq 404
        end
      end
    end
    context 'when inputs are invalid' do
      it do
        put :update_bulk
        expect(JSON.parse(response.body)["message"]).to eq "from date, to date, room type, price and availability are neccesary fields"
        expect(response.status).to eq 422
      end
    end
  end

end
