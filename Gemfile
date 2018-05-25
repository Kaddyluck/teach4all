source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'devise', '~> 4.3'
gem 'dotenv-rails', '~> 2.2', '>= 2.2.1'
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.3'
gem 'jbuilder', '~> 2.5'
gem 'haml-rails', '~> 1.0'
gem 'kaminari'
gem 'bootstrap4-kaminari-views'
gem "paperclip", "~> 5.2.1"
gem 'pdf-forms'
gem 'pg', '~> 0.18'
gem 'pretender', '~> 0.3.2'
gem 'puma', '~> 3.7'
gem 'pundit', '~> 1.1'
gem 'rails', '~> 5.1.4'
gem 'sass-rails', '~> 5.0'
gem 'searchkick', '~> 2.4'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'
gem 'whenever', '~> 0.10.0', require: false
gem 'sidekiq'
gem 'simple_form'

group :development, :test do
  gem 'awesome_print', '~> 1.8'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'capybara-webkit'
  gem 'factory_bot_rails', '~> 4.0'
  gem 'faker'
  gem 'pry-rails', '~> 0.3.6'
  gem 'rspec-rails', '~> 3.7', '>= 3.7.2'
end

group :development do
  gem 'letter_opener'
  gem 'better_errors', '~> 2.4'
  gem 'binding_of_caller', '~> 0.7.3'
  gem 'bullet', '~> 5.7'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop', '~> 0.52.0', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
