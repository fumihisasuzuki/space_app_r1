source 'https://rubygems.org'

gem 'rails',        '5.1.7'
gem 'puma',         '~> 3.7'
gem 'sass-rails',   '~> 5.0'
gem 'uglifier',     '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks',   '~> 5'
gem 'jbuilder',     '~> 2.5'

# 追加
gem 'rails-i18n' # 日本語化
#たぶんいらない: gem 'bcrypt' # has_secure_passwordを使ってパスワードをハッシュ化
gem 'faker' # 実際に存在していそうな名前を生成
gem 'bootstrap-sass' # bootstrap
gem 'will_paginate' # ページネーション
gem 'bootstrap-will_paginate' # ページネーションにbootstrapを適用
gem 'roo' # Excel, CSV, OpenOffice, GoogleSpreadSheetを開くことが可能
gem 'enum' # enumメソッドを使える
gem 'enum_help' # enumメソッドの日本語化
gem 'clipboard-rails' # クリップボードにコピー
gem 'rounding' # floor_to(xx.minutes) 時刻をxx単位に切り捨て、ceil_to(xx)で切り上げ

# ログイン機能
gem 'devise' # 簡単に認証機能を実装
gem 'omniauth' # 元締め
gem 'omniauth-line' # 既に登録済みのLINEアカウントを利用して、あるサービスに登録する事ができる仕組みを提供しているプロトコル

# 環境変数の設定
gem 'dotenv-rails'

# local化した際に追加
gem 'wdm', '>= 0.1.0' if Gem.win_platform?

group :development, :test do
  # gem 'sqlite3'
  gem 'mysql2'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 4.0.1'
  gem "factory_bot_rails"
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
  gem "letter_opener" # 開発環境でメールを送るとブラウザで別タブでメールが開くように設定
end

group :test do
  # 手書きだと長くて複雑でエラーが起きやすいRailsのテストを、1行で書けるようになる。(RspecとMinitestに対応)
  gem 'shoulda-matchers', '~> 4.0'
end

# Herokuへデプロイ
# 本番環境(heroku)ではPostgreSQLを使用
group :production do
  gem 'pg', '~> 1.2', '>= 1.2.3'#gem 'pg', '0.20.0'
end

# Windows環境ではtzinfo-dataというgemを含める必要があります
# Mac環境でもこのままでOKです
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
