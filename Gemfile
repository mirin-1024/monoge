source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.3'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Personal Gems
# エラーメッセージの日本語化
gem 'rails-i18n'
# サンプルユーザーの作成
gem 'faker'
# ページネーションの実装
gem 'will_paginate'
# Bootstrap4に即したページネーションの実装
gem 'will_paginate-bootstrap4'
# 画像処理用のgem
gem 'carrierwave'
# 画像のリサイズ
gem 'mini_magick'
# 楽天市場API
gem 'rakuten_web_service'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # Rspecの導入
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'capybara'
  gem 'factory_bot_rails'
  # メール本文の日本語をJISコードに書き換える
  # gem 'mail-iso-2022-jp'
  # テストDBのデータを削除
  gem 'database_cleaner-active_record'
  # 画像処理用のgem
  gem 'image_processing'
  # Active Storageのバリデーション（carrierwave使用のため削除検討）
  gem 'active_storage_validations'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Rubocop
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
