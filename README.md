1. Install ruby
`https://www.digitalocean.com/community/tutorials/how-to-install-ruby-and-set-up-a-local-programming-environment-on-ubuntu-16-04`

2. Install libraries required
    `gem install bundler`

3. Clone this repository
    `git clone https://github.com/shikshachauhan/hotels.git`

6. Checkout to this directory
    `cd hotels`

7. Initialize libraries
    `bundle install`

8. Create database
    `rake db:setup`

9. Seed data
    `rake db:seed`

10. Run application
    `ruby server`


# Test cases

1. Checkout to this directory
    `cd hotels`

3. Run command
    `bundle exec rspec`

# API's served

1. Room details
    `GET /room_details?start_date=2019-01-01&end_date=2019-01-20&hotel_name=The Hotel`
2. Update individual record
    `PUT /room_detail/:id?price=5000&availability=6`
3. Update bulk records
    `PUT /room_details/update_bulk?hotel_name=The+Hotel&room_type=Single&from_date=2019-01-01&to_date=2019-01-10&all_day=true&all_weekday=false&all_weekend=false&all_monday=true&all_tuesday=false&all_wednesday=true&all_thursday=false&all_friday=true&all_saturday=false&all_sunday=true&price=2000&availability=4`
