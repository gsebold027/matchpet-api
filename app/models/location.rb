# * lat: float
# * lng: float
# * address: string

class Location < ApplicationRecord
  has_many :users
  has_many :pets

  validates_presence_of :lat
  validates_presence_of :lng
  validates_presence_of :address
end
