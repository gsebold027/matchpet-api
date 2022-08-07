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
                   "#{users(:one).location}", "#{users(:one).location.lat}", "#{users(:one).location.lng}"]

    assert_response :ok

    user_params.each { |param| assert_includes response.body, param }
    user_values.each { |value| assert_includes response.body, value }
  end

  test 'Successful update a user' do
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
end
