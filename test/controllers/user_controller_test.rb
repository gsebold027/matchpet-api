require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  test 'Successful create a new user' do
    user = {
      name: 'Teste',
      phone: '(41) 99999-9999',
      email: 'gustavo@gmail.com',
      password: 'teste',
      password_confirmation: 'teste'
    }
    location = {
      lat: 1.0,
      lng: 1.0,
      address: 'teste'
    }
    post '/user', params: { user:, location: }

    expected_response = 'User created successfully'
    assert_response :created
    assert_includes response.body, expected_response
  end

  test 'Unsuccessful create a new user without password' do
    user = {
      name: 'Teste',
      phone: '(41) 99999-9999',
      email: 'gustavo@gmail.com'
    }
    location = {
      lat: 1.0,
      lng: 1.0,
      address: 'teste'
    }
    post '/user', params: { user:, location: }

    expected_response = 'Password can\'t be blank'
    assert_response :unprocessable_entity
    assert_includes response.body, expected_response
  end

  test 'Successful get a user' do
    login_res = login
    token = login_res['token']
    id = login_res['id']
    get "/user/#{id}", headers: { 'Authorization' => token }

    user_params = %w[id name email phone location lat lng]
    user_values = ["#{users(:one).id}", "#{users(:one).name}", "#{users(:one).email}", "#{users(:one).phone}",
                   "#{users(:one).location.lat}", "#{users(:one).location.lng}"]

    assert_response :ok

    user_params.each { |param| assert_includes response.body, param }
    user_values.each { |value| assert_includes response.body, value }
  end

  test 'Successful update a user' do
    login_res = login
    token = login_res['token']
    id = login_res['id']

    user = {
      name: 'TestUpdate',
      phone: '(41) 92345-6789',
      email: users(:one).email,
      password: 'teste',
      password_confirmation: 'teste'
    }
    location = {
      lat: users(:one).location.lat,
      lng: users(:one).location.lng,
      address: users(:one).location.address
    }
    put "/user/#{id}", headers: { 'Authorization' => token }, params: { user:, location: }

    expected_response = 'User updated successfully'
    assert_response :ok
    assert_includes response.body, expected_response
    assert_equal user[:name], User.find(users(:one).id).name
    assert_equal user[:phone], User.find(users(:one).id).phone
  end

  test 'Successful delete a user' do
    login_res = login
    token = login_res['token']
    id = login_res['id']
    
    delete "/user/#{id}", headers: { 'Authorization' => token }

    expected_response = 'User deleted successfully'
    assert_response :ok
    assert_includes response.body, expected_response
    assert_nil User.find_by_id(users(:one).id)
  end

  test 'Successful get all users' do
    login_res = login
    token = login_res['token']
    id = login_res['id']
    get "/user", headers: { 'Authorization' => token }

    user_params = %w[id name email phone location_id]
    user_values = ["#{users(:one).id}", "#{users(:one).name}", "#{users(:one).email}", "#{users(:one).phone}",
                   "#{users(:one).location_id}"]

    assert_response :ok

    user_params.each { |param| assert_includes response.body, param }
    user_values.each { |value| assert_includes response.body, value }
  end

end
