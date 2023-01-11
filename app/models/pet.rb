# * name: string
# * specie: integer
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

    validates_presence_of :name, :age, :weight, :description, :neutered, :special_need, :specie, :gender, :status,
                          :location, :user, :photo

    scope :filter_by_userId, ->(user_id) { where(user_id:) }
    scope :filter_by_status, ->(normalized_name) { where(status: Status.where(normalized_name:)) }
    scope :filter_by_species, ->(normalized_name) { where(specie: Specie.where(normalized_name:)) }
    scope :filter_by_gender, ->(normalized_name) { where(gender: Gender.where(normalized_name:)) }
    scope :filter_by_minAge, ->(min_age) { where(age: min_age..) }
    scope :filter_by_maxAge, ->(max_age) { where(age: ..max_age) }
    scope :filter_by_size, ->(normalized_name) { where size: Size.where(normalized_name:) }
    scope :filter_by_specialNeed, ->(special_need) { where(special_need:) }
end
