source "https://rubygems.org"

gem "rails", "~> 5.0.0", ">= 5.0.0.1"
gem "puma", "~> 3.0"
gem "pg"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"

group :development, :test do
  gem "rspec-rails"
  gem "byebug", platform: :mri
end

group :development do
  gem "web-console"
  gem "listen", "~> 3.0.5"
  gem "guard-rspec", require: false

  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "spring-commands-rspec"
end

group :test do
  gem "shoulda-matchers"
  gem "rspec_api_documentation"
end

group :development, :test do
  gem "factory_girl_rails"
  gem "ffaker"
end
