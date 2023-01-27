class ValidatorInterest < ActiveModel::Validator
    def validate(record)
        return record.errors.add :user, 'Duplicated interest' unless Interest.find_by(user: record.user,
                                                                                      pet: record.pet).nil?
    end
end

class Interest < ApplicationRecord
    belongs_to :user
    belongs_to :pet

    validates_with ValidatorInterest

    scope :filter_by_petId, ->(pet_id) { where(pet_id:) }
end
