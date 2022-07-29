# * name: string
# * phone: string
# * email: string
# * password_digest: string
# * location: Location

# ! to manipulate password use:
#   * password: string
#   * password_confirmation: string

class User < ApplicationRecord
  belongs_to :location

  has_secure_password
  validates_presence_of :name
  validates_presence_of :phone
  validates_presence_of :email
  validates_presence_of :location

  validates_uniqueness_of :email

  validates :phone, format: { with: /[(](\d{2})[)] 9(\d{4})-(\d{4})/ } # -> (41) 99999-9999
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
