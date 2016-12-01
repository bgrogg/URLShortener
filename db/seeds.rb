# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
ActiveRecord::Base.transaction do

  ShortenedUrl.destroy_all
  ShortenedUrl.create(long_url: "this is long", short_url: "short", user_id: 1)

  User.destroy_all
  User.create(email: "yo@hotmail.com")
end
 
