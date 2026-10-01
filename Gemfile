source 'https://rubygems.org'

ruby '3.1.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.6'
gem 'blueprinter', '~> 1.3'
gem 'figaro', '~> 1.3'
gem 'pagy', '~> 9.3.5'
# Rails 7.1's JSON encoder passes options removed in json 3.x.
gem 'json', '< 3.0'

# PostgreSQL is used in every environment.
gem 'pg', '~> 1.5'
gem 'rspec-rails', '~> 7.1', group: %i[development test]
gem 'factory_bot_rails', '~> 6.4', group: %i[development test]
gem 'test-prof', '~> 1.4', group: %i[development test]

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[ mswin mswin64 mingw x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[ mri mswin mswin64 mingw x64_mingw ]
end

group :development do
  gem 'rubocop-rails-omakase', require: false
end
