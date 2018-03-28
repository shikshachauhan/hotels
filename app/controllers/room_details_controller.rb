class RoomDetailsController < ApplicationController
  # validate_inputs will validate input parameter for bulk update and return invalid response if invalid
  before_action :validate_inputs, only: :update_bulk
  # load_hotel will load hotel object from database based on hotel_name parameter
  before_action :load_hotel, only: [:index, :update_bulk]
  #load_room_detail will run in case if individial record update. lokks for :id parameter in request and fetches the record from DB
  before_action :load_room_detail, only: :update
  #set_date_range parses start_date and end_date string from parameters and convert it to date objects used later in fetching date from DB
  before_action :set_date_range, only: :index
  #set_dates_to_be_updated loads the exact dates on which update has to run
  before_action :set_dates_to_be_updated, only: :update_bulk

  #This action will load all the Room Details with start_date and end_date filters
  def index
    Rails.logger.info("fetching room details from #{@start_date} to #{@end_date}")
    # @hotel.room_type_ids loads all the room type ids associated with hotel
    @room_details = RoomDetail.where(room_type_id: @hotel.room_type_ids)
      .where("date >= ? and date <= ?", @start_date, @end_date).map(&:as_json)
    render json: { data: @room_details }, status: :ok
  end

  #This action will update an individual record
  def update
    Rails.logger.info("Updating Room details id #{@room_detail.id} with #{get_parameters}")
    #get_parameters method will return a hash of rows to be updated with their values
    if @room_detail.update(get_parameters) #updates record in DB
      render json: { message: 'Update Successful' }, status: :ok
    else
      Rails.logger.info("Update faidel due to #{@room_detail.errors.full_messages}")
      #This error response is sent in case of updation failure due to db level or application level validations
      render json: { message: @room_detail.errors.full_messages }, status: :unprocessable_entity
    end
  end

  #This action will bulk update multiple records
  def update_bulk
    Rails.logger.info("Updating Room Type #{params[:room_type]} on dates #{@dates} with #{get_parameters}")
    #This loads hotels with selected room type and dates and update them all.
    RoomDetail.where({
      room_type_id: @hotel.room_types.where(room_type: RoomType::TYPE[params[:room_type]]).map(&:id),
      date: @dates
    }).update_all(get_parameters) #update_all fires bulk update in DB
    render json: { message: 'Update Successful' }, status: :ok
  end

  private

    def get_parameters
      update_hash = {}
      update_hash[:price] = params[:price].to_i if params[:price].present?
      update_hash[:availability] = params[:availability].to_i if params[:availability].present?
      update_hash
    end

    def sanitize_days_filters
      all_unset_flag = true
      params.keys.select{|key| key.include? 'all_'}.each do |key|
        params[key] = (if params[key] == 'true'
                        all_unset_flag = false
                        true
                      end)
      end

      params[:all_day] = true if all_unset_flag
    end

    def set_dates_to_be_updated
      @dates = []
      @from_date = Date.parse(params[:from_date])
      @to_date = Date.parse(params[:to_date])
      sanitize_days_filters
      @from_date.upto(@to_date) do |date|
        day_name = date.strftime("%A")
        if params[:all_day] || ((day_name == "Monday") && (params[:all_weekday] || params[:all_monday]) ||
        (day_name == "Tuesday") && (params[:all_weekday] || params[:all_tuesday]) ||
        (day_name == "Wednesday") && (params[:all_weekday] || params[:all_wednesday]) ||
        (day_name == "Thursday") && (params[:all_weekday] || params[:all_thursday]) ||
        (day_name == "Friday") && (params[:all_weekday] || params[:all_friday]) ||
        (day_name == "Saturday") && (params[:all_weekend] || params[:all_saturday]) ||
        (day_name == "Sunday") && (params[:all_weekend] || params[:all_sunday]))
          @dates << date
        end

      end
    end

    def load_hotel
      @hotel = Hotel.includes(:room_types).where(name: params[:hotel_name]).last
      render json: {message: 'Not Found'}, status: :not_found unless @hotel
    end

    def set_date_range
      @start_date = Date.parse(params[:start_date] ||= '2019-01-01')
      @end_date = Date.parse(params[:end_date] ||= '2019-01-10')
    end

    def validate_inputs
      unless (Date.strptime(params[:from_date], "%Y-%m-%d") &&
              Date.strptime(params[:to_date], "%Y-%m-%d") &&
              params[:price].present? && params[:availability].present? &&
              params[:room_type].present? rescue false)
        render json: {message: "from date, to date, room type, price and availability are neccesary fields"}, status: :unprocessable_entity
      end
    end

    def load_room_detail
      @room_detail = RoomDetail.find_by_id(params[:id])
      render json: {message: 'Not Found'}, status: :not_found unless @room_detail
    end
end
