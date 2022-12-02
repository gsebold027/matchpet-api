class Size < ApplicationRecord
    has_many :pets

    SIZES = {
        small: 'Pequeno',
        medium: 'Médio',
        big: 'Grande'
    }

    def self.initialize
        SIZES.each do |key, value|
            if Size.find_by(normalized_name: key).nil?
                Size.create(display_name: value, normalized_name: key)
            end
        end
    end

    class << self
        SIZES.each do |key, value|
            define_method(key) do
                return Size.find_by_normalized_name(key)
            end
        end
    end
end
