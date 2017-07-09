source 'https://rubygems.org'
ruby '2.3.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

########################
# Auth and Permissions #
########################

gem 'devise' # Use Devise for user authentication

########
# Misc #
########

gem 'simple_form' # Use Simple Form for forms
gem "rails_best_practices" # code metric tool to check the quality of Rails code.
gem 'reek', '~> 4.6', '>= 4.6.2' # modules and methods and reports any code smells it finds.
gem 'figaro' # app configuration using ENV variables and a single YAML file
gem 'bootstrap', '~> 4.0.0.alpha6' # Use Bootstrap 4 for front-end framework
gem 'pusher'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.3.3'
end

gem 'rails', '~> 5.0.2'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.6.2'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails' # Use jquery as the JavaScript library
gem 'jquery-ui-rails' # Use jQueryUI draggable and sortable to move pieces
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'pry-rails' # Use pry for multiple functionality inside rails console
  gem 'rspec-rails', '~> 3.5' # Use rspec as testing framework
  gem "factory_girl_rails", "~> 4.0" # Use FactoryGirl to use factories
  gem "simplecov" # codeclimate-test-reporter
  gem "codeclimate-test-reporter", "~> 1.0.0" # codeclimate-test-reporter
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
