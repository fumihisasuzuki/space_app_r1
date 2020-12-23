require 'rails_helper'

RSpec.describe Event, type: :model do
  if User.find_by(email: "sample@email.com").blank?
    debugger
    FactoryBot.build(:user)
    # User.create!(
    #   id: 1,
    #   user_name: "ユーザーA",
    #   email: "sample@email.com",
    #   password: "password",
    #   admin: false,
    # )
  end
  # 姓、名、メール、パスワードがあれば有効な状態であること
  it "is valid with a event_name, event_status, and chouseisan_check" do
    expect(FactoryBot.build(:event)).to be_valid
  end

  # 名がなければ無効な状態であること
  it "is invalid without a event_name"
  # 姓がなければ無効な状態であること
  it "is invalid without a event_status"
  # メールアドレスがなければ無効な状態であること
  it "is invalid without an chouseisan_check"
  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate chouseisan_url"
  # ユーザーのフルネームを文字列として返すこと
  it "returns a event_name as a string"
end
