class ValidatorFavoritePet < ActiveModel::Validator
  def validate(record)
      return record.errors.add :pet, "Duplicated favorite" unless FavoritePet.find_by(user: record.user, pet: record.pet).nil?
  end
end

class FavoritePet < ApplicationRecord
  belongs_to :user
  belongs_to :pet

  validates_with ValidatorFavoritePet
  validates_presence_of :user, :pet 
end
