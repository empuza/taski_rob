source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.0'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.12'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
# XSS/CSRF safe JWT auth designed for SPA
gem 'jwt_sessions', '~> 2.4.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4', '>= 5.2.4.1'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 1.1.1'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # RSpec testing framework
  gem 'rspec-rails', '~> 3.7'
end

group :test do
  # Fixtures replacement with a straightforward definition syntax
  gem 'factory_bot_rails', '~> 4.8'
  # A library for generating fake data such as names, addresses, and phone numbers.
  gem 'faker', '~> 2.10.2'
  # Simple one-liner tests for common Rails functionality
  gem 'shoulda-matchers', '~> 3.1.3'
  # Code coverage analysis tool for Ruby
  gem 'simplecov', '~> 0.18.5'
end

group :development do
  # Listens to file modifications and notifies you about the changes
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.1.0'
  # Makes Spring watch the filesystem for changes using Listen rather than by polling the filesystem
  gem 'spring-watcher-listen', '~> 2.0.0'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
