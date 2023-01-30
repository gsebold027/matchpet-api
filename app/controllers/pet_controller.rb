class PetController < ApplicationController
    before_action :authorize_request
    before_action :find_pet, except: %i[create index]

    # GET /pet
    def index
        pets_raw = Pet.all
        filtering_params(params).each do |key, value|
            value = value.split(',') if %w[species gender size].include?(key)
            pets_raw = pets_raw.public_send("filter_by_#{key}", value) if value.present?
        end

        pets_raw = pets_raw.where.not(user: @current_user) if params[:userId].nil?

        if !params[:lat].blank? && !params[:lng].blank? && !params[:distance].blank?
            pets_raw = Pet.filter_by_distance({ lat: params[:lat], lng: params[:lng] }, params[:distance].to_i,
                                              pets_raw)
        end

        @pets = []
        pets_raw.each do |pet|
            @pets << get_pet_info(pet)
        end
        render json: @pets, status: :ok
    end

    # GET /pet/{id}
    def show
        pet = get_pet_info @pet

        render json: pet, status: :ok
    end

    # POST /pet
    def create
        location = Location.new(lat: (params[:lat].blank? ? nil : params[:lat].to_f),
                                lng: (params[:lng].blank? ? nil : params[:lng].to_f), address: params[:address])
        bd_location = Location.find_by(lat: location.lat, lng: location.lng)

        if bd_location.nil?
            unless location.save
                errors = location.errors.map { |error| { "#{error.attribute}" => error.full_message } }
                @response = { message: errors }
                render json: @response, status: :unprocessable_entity
                return
            end
        else
            location = bd_location
        end

        @pet = Pet.new(name: params[:name], specie: Specie.find_by(normalized_name: params[:species]),
                       gender: Gender.find_by(normalized_name: params[:gender]), size: Size.find_by(normalized_name: params[:size]), status: Status.find_by(normalized_name: params[:status]), breed: params[:breed], age: (params[:age].blank? ? nil : params[:age].to_i), weight: (params[:weight].blank? ? nil : params[:weight].to_f), description: params[:description], neutered: (params[:neutered].blank? ? nil : params[:neutered].to_i), special_need: (params[:special_need].blank? ? nil : params[:special_need].to_i), photo: params[:photo], user: @current_user, location:)

        if @pet.save
            @response = { message: 'Pet created successfully', id: @pet.id }
            render json: @response, status: :created
        else
            errors = @pet.errors.map { |error| { "#{error.attribute}" => error.full_message } }

            @response = { message: errors }
            render json: @response, status: :unprocessable_entity
        end
    end

    # PATCH /pet/{id}
    def update
        unless @current_user.id == @pet.user.id
            render json: { error: 'unauthorized' }, status: :unauthorized
            return
        end
        new_owner = !params[:user_id].nil? && (params[:user_id] != @pet.user.id) ? true : false

        begin
            if new_owner
                @firebase_token = Firebase.get_token(@pet.user.id)
            end
        rescue Exception => e
            render json: { error: 'Not found user in firebase' }, status: :unauthorized
            return
        end

        to_update_information = {}

        if !params[:lat].nil? && !params[:lng].nil?
            location = Location.new(lat: (params[:lat].blank? ? nil : params[:lat].to_f),
                                    lng: (params[:lng].blank? ? nil : params[:lng].to_f), address: params[:address])
            bd_location = Location.find_by(lat: location.lat, lng: location.lng)

            if bd_location.nil?
                unless location.save
                    errors = location.errors.map { |error| { "#{error.attribute}" => error.full_message } }
                    @response = { message: errors }
                    render json: @response, status: :unprocessable_entity
                    return
                end
            else
                location = bd_location
            end
            to_update_information[:location] = location
        end


        params.slice(:name, :species, :gender, :size, :status, :breed, :age, :weight, :description, :neutered,
                     :special_need, :photo, :user_id).each do |key, value|
            case key
            when 'species'
                to_update_information[:specie] = Specie.find_by(normalized_name: value)
            when 'gender'
                to_update_information[:gender] = Gender.find_by(normalized_name: value)
            when 'size'
                to_update_information[:size] = Size.find_by(normalized_name: value)
            when 'status'
                to_update_information[:status] = Status.find_by(normalized_name: value)
            else
                to_update_information[key.to_sym] = value
            end
        end

        if @pet.update(to_update_information)
            Firebase.notification(@firebase_token, 'Adoção confirmada', "Parabéns, o pet #{@pet.name} agora é seu!") if new_owner
            @response = { message: 'Pet updated successfully', id: @pet.id }
            render json: @response, status: :created
        else
            errors = @pet.errors.map { |error| { "#{error.attribute}" => error.full_message } }

            @response = { message: errors }
            render json: @response, status: :unprocessable_entity
        end
    end

    # DELETE /user/{id}
    def destroy
        render json: { error: 'unauthorized' }, status: :unauthorized unless @current_user.id == @pet.user.id
        @pet.destroy
        @response = { message: 'Pet deleted successfully' }
        render json: @response, status: :ok
    end

    private

    def find_pet
        @pet = Pet.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Pet not found' }, status: :not_found
    end

    def location_params
        params.permit(:lat, :lng, :address)
    end

    def pet_params
        params.permit
    end

    def get_pet_info(pet)
        pet_info = {
            id: pet.id,
            name: pet.name,
            specie: pet.specie.slice(:id, :display_name, :normalized_name),
            gender: pet.gender.slice(:id, :display_name, :normalized_name),
            size: pet.size.slice(:id, :display_name, :normalized_name),
            status: pet.status.slice(:id, :display_name, :normalized_name),
            breed: pet.breed,
            age: pet.age,
            weight: pet.weight,
            description: pet.description,
            neutered: pet.neutered,
            special_need: pet.special_need,
            location: pet.location.slice(:id, :lat, :lng, :address),
            photoUrl: pet.photo.url,
            is_user_favorite: FavoritePet.find_by(user: @current_user, pet:).nil? ? 0 : 1
        }
        pet_info[:user] = {
            id: pet.user.id,
            name: pet.user.name,
            phone: pet.user.phone,
            email: pet.user.email,
            location: pet.user.location.slice(:id, :lat, :lng, :address)
        }

        pet_info
    end

    def filtering_params(params)
        params.slice(:userId, :status, :species, :gender, :minAge, :maxAge, :size, :specialNeed)
    end
end
