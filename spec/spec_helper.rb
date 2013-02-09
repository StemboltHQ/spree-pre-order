require 'rubygems'
require 'spork'

Spork.prefork do
  # Configure Rails Environment
  ENV['RAILS_ENV'] = 'test'

  require 'simplecov'
  require 'simplecov-rcov'

  class SimpleCov::Formatter::MergedFormatter
    def format(result)
      SimpleCov::Formatter::HTMLFormatter.new.format(result)
      SimpleCov::Formatter::RcovFormatter.new.format(result)
    end
  end

  SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
  SimpleCov.start 'rails'

  require File.expand_path('../dummy/config/environment.rb',  __FILE__)

  require 'rspec/rails'
  require 'ffaker'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

  # Requires factories defined in spree_core
  require 'spree/core/testing_support/factories'
  require 'spree/core/testing_support/controller_requests'
  require 'spree/core/testing_support/authorization_helpers'
  require 'spree/core/url_helpers'

  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods
    config.include Spree::Core::TestingSupport::ControllerRequests, :type => :controller

    # == URL Helpers
    #
    # Allows access to Spree's routes in specs:
    #
    # visit spree.admin_path
    # current_path.should eql(spree.products_path)
    config.include Spree::Core::UrlHelpers

    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  FactoryGirl.find_definitions

  if ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
  end
end
