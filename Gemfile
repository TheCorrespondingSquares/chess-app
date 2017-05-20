source 'https://rubygems.org'

# Use ruby 2.3.1
ruby '2.3.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

########################
# Auth and Permissions #
########################

# Use Devise for user authentication
gem 'devise'

########
# Misc #
########

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.3.3'

  # Use Bootstrap 4 for front-end framework
  gem 'bootstrap', '~> 4.0.0.alpha6'
end


# app configuration using ENV variables and a single YAML file
gem 'figaro'

gem 'rails', '~> 5.0.2'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.6.2'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri

  # Use pry for multiple functionality inside rails console
  gem 'pry-rails'

  # Use rspec as testing framework
  gem 'rspec-rails', '~> 3.5'

  # Use FactoryGirl to use factories
  gem "factory_girl_rails", "~> 4.0"

  # codeclimate-test-reporter
  gem "simplecov"

  # codeclimate-test-reporter
  gem "codeclimate-test-reporter", "~> 1.0.0"
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
