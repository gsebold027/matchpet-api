ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/test/'
  add_filter '/app/mailers/'
  add_filter '/app/jobs/'
  add_filter '/app/channels/'
end


require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def login
    post '/auth/login', params: { email: users(:one).email, password: 'teste' }

    JSON.parse(response.body)
  end

  # Add more helper methods to be used by all tests here...
end
