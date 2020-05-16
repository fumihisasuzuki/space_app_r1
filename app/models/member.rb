class Member < ApplicationRecord
  belongs_to :event
  has_many :schedules, through: :member_schedules
  has_many :member_schedules, dependent: :destroy
  
  validates :member_name, presence: true
  validates :remark, length: { maximum: 200 }, allow_blank: true
end
