class Interest < ApplicationRecord
    belongs_to :user
    belongs_to :pet

    validate :duplicated?, on: :create

    scope :filter_by_petId, ->(pet_id) { where(pet_id:) }

    private

    def duplicated?
        errors.add :user, 'Duplicated interest' unless Interest.find_by(user: self.user,
                                                                                      pet: self.pet).nil?
    end
end
