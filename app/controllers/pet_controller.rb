class PetController < ApplicationController
    before_action :authorize_request
    before_action :find_pet, except: %i[create index]
  
    # GET /user
    def index
       @pets = Pet.all
       render json: @pets, status: :ok
    end
  
    # GET /user/{id}
    def show
      render json: @pet.to_json, status: :ok
    end
  
    # POST /pet
    def create
        params
        location = Location.new(lat: params[:lat].to_f, lng: params[:lng].to_f, address: params[:address])
        bd_location = Location.find_by(lat: location.lat, lng: location.lng)
  
        if bd_location.nil?
            location.save
        else
            location = bd_location
        end
    
        @pet = Pet.new(name: params[:name], species: params[:species].to_i, gender: params[:gender].to_i, size: params[:size].to_i, status: params[:status].to_i, breed: params[:breed], age: params[:age].to_i, weight: params[:weight].to_f, description: params[:description], neutered: params[:neutered].to_i, special_need: params[:special_need].to_i)
    
        @pet.location = location
        @pet.user = @current_user
    
        if @pet.save
            @response = { message: 'Pet created successfully', id: @pet.id }
            render json: @response, status: :created
        else
            errors = @pet.errors.map { |error| { "#{error.attribute}" => error.full_message } }
    
            @response = { message: errors }
            render json: @response, status: :unprocessable_entity
        end
    end
  
    # PUT /user/{id}
    def update
    #   render json: { error: 'unauthorized' }, status: :unauthorized unless @current_user.id == @user.id
    #   location = Location.new(location_params)
    #   bd_location = Location.find_by(lat: location.lat, lng: location.lng)
  
    #   if bd_location.nil?
    #     location.save
    #   else
    #     location = bd_location
    #   end
  
    #   @user.location = location
  
    #   if @user.update(user_params)
    #     @response = { message: 'User updated successfully' }
    #     render json: @response, status: :ok
    #   else
    #     errors = @user.errors.map { |error| { "#{error.attribute}" => error.full_message } }
  
    #     @response = { message: errors }
    #     render json: @response, status: :unprocessable_entity
    #   end
    end
  
    # DELETE /user/{id}
    def destroy
    #   render json: { error: 'unauthorized' }, status: :unauthorized unless @current_user.id == @user.id
    #   @user.destroy
    #   @response = { message: 'User deleted successfully' }
    #   render json: @response, status: :ok
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
      params.permit()
    end
end
