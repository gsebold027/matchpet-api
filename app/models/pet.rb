# * name: string
# * species: integer
# * gender: integer
# * size: integer
# * status: integer
# * breed: string
# * age: integer
# * weight: float
# * description: string
# * neutered: boolean
# * special_need: boolean
# * location: Location
# * user: User

class Pet < ApplicationRecord
  belongs_to :user
  belongs_to :location
  belongs_to :gender
  belongs_to :size
  belongs_to :specie
  belongs_to :status

  has_one_attached :photo

  validates_presence_of :species
  validates_presence_of :gender
  validates_presence_of :status

  validates_presence_of :location

end
