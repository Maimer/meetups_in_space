class Meetup < ActiveRecord::Base
  has_many :users, through: :usermeetups
  has_many :usermeetups
  has_many :comments

  validates :name, presence: true
  validates :description, presence: true
  validates :location, presence: true
end
