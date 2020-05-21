class Member < ApplicationRecord
  belongs_to :event
  has_many :schedules, through: :member_schedules
  has_many :member_schedules, dependent: :destroy
  accepts_nested_attributes_for :member_schedules, allow_destroy: true
  
  validates :member_name, presence: true
  validates :remark, length: { maximum: 200 }, allow_blank: true
end
