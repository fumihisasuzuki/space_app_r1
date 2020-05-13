class Member < ApplicationRecord
  belongs_to :event
  has_many :schedules, through: :member_schedules
  has_many :member_schedules, dependent: :destroy
end
