class Event < ApplicationRecord
  belongs_to :user
  has_many :schedules, dependent: :destroy
  
  validates :event_name, presence: true
  validates :chouseisan_note, length: { maximum: 200 }
  validates :reference, length: { maximum: 200 }
  
end
