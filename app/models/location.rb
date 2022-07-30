# * lat: float
# * lng: float
# * address: string

class Location < ApplicationRecord
  has_many :users

  validates_presence_of :lat
  validates_presence_of :lng
  validates_presence_of :address
end
