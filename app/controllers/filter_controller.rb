class FilterController < ApplicationController
    before_action :authorize_request

    def gender
        @genders = Gender.all

        render json: @genders, status: :ok
    end

    def size
        @sizes = Size.all

        render json: @sizes, status: :ok
    end

    def specie
        @species = Specie.all

        render json: @species, status: :ok
    end

    def status
        @status = Status.all

        render json: @status, status: :ok
    end
end
