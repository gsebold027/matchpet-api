class Gender < ApplicationRecord
    has_many :pets

    GENDERS = {
        male: 'Macho',
        female: 'Fêmea'
    }

    def self.initialize
        GENDERS.each do |key, value|
            if Gender.find_by(normalized_name: key).nil?
                Gender.create(display_name: value, normalized_name: key)
            end
        end
    end

    class << self
        GENDERS.each do |key, value|
            define_method(key) do
                return Gender.find_by_normalized_name(key)
            end
        end
    end
end
