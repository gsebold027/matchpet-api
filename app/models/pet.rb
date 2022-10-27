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

  has_one_attached :photo

  enum species: { dog: 1, cat: 2, other: 3 }
  enum gender: { male: 1, female: 2 }
  enum size: { small: 1, medium: 2, big: 3 }
  enum status: { registered: 1, available: 2, adopted: 3, missing: 4, adoption_process: 5 }

  validates_presence_of :species
  validates_presence_of :gender
  validates_presence_of :status

  validates_presence_of :location

end
