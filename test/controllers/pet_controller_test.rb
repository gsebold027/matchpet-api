require "test_helper"

class PetControllerTest < ActionDispatch::IntegrationTest
  # test 'Successful create a new pet' do
  #   login_res = login
  #   token = login_res['token']
  #   id = login_res['id']

  #   pet = {
  #     name: 'Mushu',
  #     species: 2,
  #     gender: 1,
  #     size: 2,
  #     status: 1
  #   }
  #   location = {
  #     lat: 1.0,
  #     lng: 1.0,
  #     address: 'teste pet'
  #   }
  #   post '/pet', params:  pet.merge(location) , headers: { 'Authorization' => token }

  #   expected_response = 'Pet created successfully'
  #   assert_response :created
  #   assert_includes response.body, expected_response
  # end

  # test 'Successful get a pet' do
  #   pet = {
  #     owner: owner,
  #   }
  #   owner = user(:one)

  #   login_res = login
  #   token = login_res['token']
  #   id = login_res['id']
  #   get "/pet/#{pet_id}", headers: { 'Authorization' => token }

  #   pet_params = %w[id name species gender size status breed age weight description neutered special_need location owner photoUrl]
  #   pet_values = ["#{pet(:one).id}", "#{pet(:one).name}", "#{pet(:one).species}", "#{pet(:one).gender}", "#{pet(:one).size}", "#{pet(:one).status}",
  #   "#{pet(:one).breed}", "#{pet(:one).age}", "#{pet(:one).weight}", "#{pet(:one).description}", "#{pet(:one).neutered}", "#{pet(:one).special_need}", "#{pet(:one).location}", "#{pet(:one).owner}", "#{pet(:one).photoUrl}"]

  #   assert_response :ok

  #   user_params.each { |param| assert_includes response.body, param }
  #   user_values.each { |value| assert_includes response.body, value }
  # end
  #TODO objeto location e owner

  # test 'Successful get all pets' do
  #   pet = {
  #       owner: owner,
  #    }
  #   owner = user(:one)

  #   login_res = login
  #   token = login_res['token']
  #   id = login_res['id']
  #   get "/pet", headers: { 'Authorization' => token }

  #   pet_params = %w[id name species gender size status breed age weight description neutered special_need location owner photoUrl]
  #   pet_values = ["#{pet(:one).id}", "#{pet(:one).name}", "#{pet(:one).species}", "#{pet(:one).gender}", "#{pet(:one).size}", "#{pet(:one).status}",
  #     "#{pet(:one).breed}", "#{pet(:one).age}", "#{pet(:one).weight}", "#{pet(:one).description}", "#{pet(:one).neutered}", "#{pet(:one).special_need}", "#{pet(:one).location}", "#{pet(:one).owner}", "#{pet(:one).photoUrl}"]

  #   assert_response :ok

  #   pet_params.each { |param| assert_includes response.body, param }
  #   pet_values.each { |value| assert_includes response.body, value }
  # end
  #TODO objeto location e owner

  test 'Successful delete a pet' do
    login_res = login
    token = login_res['token']
    id = login_res['id']
    
    delete "/pet/#{pet_id}", headers: { 'Authorization' => token }

    expected_response = 'User deleted successfully'
    assert_response :ok
    assert_includes response.body, expected_response
    assert_nil User.find_by_id(pet(:one).id)
  end
end
