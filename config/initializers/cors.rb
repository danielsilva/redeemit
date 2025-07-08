
# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins do |source, _env|
      if Rails.env.development? || Rails.env.test?
        # Allow any localhost port for development/testing (including dynamic Capybara ports)
        source =~ %r{\Ahttp://localhost:\d+\z}
      else
        # Production: only allow specific origins for security
        %w[].include?(source)
      end
    end

    resource '*',
             headers: :any,
             methods: %i[get post put patch delete options head]
  end
end
