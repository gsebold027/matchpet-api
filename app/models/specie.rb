class Specie < ApplicationRecord
    has_many :pets

    SPECIES = {
        dog: 'Cachorro',
        cat: 'Gato',
        others: 'Outros'
    }

    def self.initialize
        SPECIES.each do |key, value|
            if Specie.find_by(normalized_name: key).nil?
                Specie.create(display_name: value, normalized_name: key)
            end
        end
    end

    class << self
        SPECIES.each do |key, value|
            define_method(key) do
                return Specie.find_by_normalized_name(key)
            end
        end
    end
end
