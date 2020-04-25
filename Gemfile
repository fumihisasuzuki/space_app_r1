source 'https://rubygems.org'

gem 'rails',        '~> 5.1.6'
gem 'rails-i18n' # 日本語化
#たぶんいらない。 gem 'bcrypt' # has_secure_passwordを使ってパスワードをハッシュ化
gem 'faker' # 実際に存在していそうな名前を生成
gem 'bootstrap-sass' # bootstrap
gem 'will_paginate' # ページネーション
gem 'bootstrap-will_paginate' # ページネーションにbootstrapを適用
gem 'puma',         '~> 3.7'
gem 'sass-rails',   '~> 5.0'
gem 'uglifier',     '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks',   '~> 5'
gem 'jbuilder',     '~> 2.5'

# ログイン機能
gem 'devise' # 簡単に認証機能を実装
gem 'omniauth' # 元締め
gem 'omniauth-line' # 既に登録済みのLINEアカウントを利用して、あるサービスに登録する事ができる仕組みを提供しているプロトコル

# 環境変数の設定
gem 'dotenv-rails'

group :development, :test do
  gem 'sqlite3'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "letter_opener" # 開発環境でメールを送るとブラウザで別タブでメールが開くように設定
end

# Windows環境ではtzinfo-dataというgemを含める必要があります
# Mac環境でもこのままでOKです
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]