source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.1'
# Use postgres as the database for Active Record (in production)
gem 'pg'
# Use Sqlite for development/test
gem 'sqlite3'
# Utilize paranoia, which enables soft delets in Active Record
gem "paranoia", "~> 2.0"
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Devise for user authentication
gem 'devise'

# Active Admin for the admin interface
gem 'activeadmin', github: 'activeadmin'
gem 'active_admin_editor'
gem 'chart-js-rails'

# paperclip for file upload for logos
gem 'paperclip'

# Twitter Bootstrap
gem 'bootstrap-sass', '~> 3.3.4'

# generate QR codes for onboarding/invites
gem 'rqrcode'
gem 'rqrcode_png'

#debug helper
gem "awesome_print"

# annotate puts comments on the schema of the models
gem 'annotate'

# use Twitter Typeahead.JS for the score page
gem 'twitter-typeahead-rails'

# use PDFKit to make PDFs for student behavior reports
gem 'pdfkit'

# Gruff makes graph images for student behavior reports
gem 'gruff'

# Fog gem for file storage
gem 'fog', '~> 1.34.0'
gem 'unf'

# Sidekiq for background jobs
gem 'sidekiq'
# Sinatra needed for sidekiq web interface
gem 'sinatra', :require => nil
# Rubyzip to make zip file of PDFs for report generation
gem 'rubyzip'

group :development do
	# Guard runs rspec on file changes
	gem 'guard-rspec', require: false
	# Capistano for deployment
	gem 'capistrano', '~> 3.4.0'
	gem 'capistrano-rvm'
	gem 'capistrano-bundler', '~> 1.1.2'
	gem 'capistrano-rails', '~> 1.1'
	gem 'capistrano-passenger'
	gem 'capistrano-sidekiq'
end

group :development, :test do
  	# Mock model data with Factory_Girl
  	gem 'factory_girl_rails'
  	# Fuzz and generate random fake data
  	gem 'faker'
  	# run tests with RSpec
  	gem 'rspec-rails', '~> 3.0'
end

group :production do
	# run on Passenger
	gem 'passenger'
end

# CodeClimate test reporting
gem "codeclimate-test-reporter", group: :test, require: nil