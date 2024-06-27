source 'https://rubygems.org'

gem 'spree', github: 'spree/spree', branch: 'main'
gem 'spree_backend', github: 'spree/spree_backend', branch: 'main'
gem 'spree_frontend', github: 'spree/spree_legacy_frontend', branch: 'main'
gem 'spree_emails', github: 'spree/spree', branch: 'main'
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: 'main'
gem 'rails-controller-testing'

if ENV['DB'] == 'mysql'
  gem 'mysql2'
elsif ENV['DB'] == 'postgres'
  gem 'pg'
else
  gem 'sqlite3', '~> 1.4'
end

gemspec
