class Meetup < ActiveRecord::Base
  has_many :users, through: :usermeetups
  has_many :usermeetups
  has_many :comments
end
