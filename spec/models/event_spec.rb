require 'rails_helper'

RSpec.describe Event, type: :model do  
  user = FactoryBot.build(:user)
  user.save! if User.find_by(user_name: user.user_name).blank?

  # 姓、名、メール、パスワードがあれば有効な状態であること
  it "is valid with a event_name, event_status, and chouseisan_check" do
    expect(FactoryBot.build(:event)).to be_valid
  end

  # 名がなければ無効な状態であること
  describe "の#{:event_name}がnilだと無効。" do
    it { should validate_presence_of(:event_name) }
  end

end
