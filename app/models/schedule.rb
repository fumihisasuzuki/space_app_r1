class Schedule < ApplicationRecord
  belongs_to :event
  has_many :members, through: :member_schedules
  has_many :member_schedules, dependent: :destroy
  accepts_nested_attributes_for :member_schedules
end
