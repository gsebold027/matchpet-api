require 'test_helper'

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  test 'Successful login' do
    post '/auth/login', params: { email: users(:one).email, password: 'teste' }

    assert_response :ok
  end
  test 'Unsuccessful login' do
    post '/auth/login', params: { email: users(:one).email, password: '' }

    assert_response :unauthorized
  end
end
