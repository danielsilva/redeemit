# Page Object Helper for acceptance tests
module PageObjectHelper
  def page_object(page_class)
    page_class.new
  end
end

RSpec.configure do |config|
  config.include PageObjectHelper, type: :acceptance
end

# Load all page objects after BasePage is defined
Dir[Rails.root.join('spec/page_objects/**/*.rb')].each { |f| require f }
