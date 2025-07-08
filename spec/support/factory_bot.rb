# frozen_string_literal: true

# FactoryBot configuration
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  # Lint factories to ensure they're valid
  config.before(:suite) do
    DatabaseCleaner.start
    FactoryBot.lint
  ensure
    DatabaseCleaner.clean
  end
end
