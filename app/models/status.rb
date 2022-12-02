class Status < ApplicationRecord
    has_many :pets

    STATUS = {
        registered: 'Registrado',
        available: 'Para adoção',
        adopted: 'Adotado',
        missing: 'Perdido',
        adoption_process: 'Em processo de adoção'
    }

    def self.initialize
        STATUS.each do |key, value|
            if Status.find_by(normalized_name: key).nil?
                Status.create(display_name: value, normalized_name: key)
            end
        end
    end

    class << self
        STATUS.each do |key, value|
            define_method(key) do
                return Status.find_by_normalized_name(key)
            end
        end
    end
end
