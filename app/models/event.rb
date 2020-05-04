class Event < ApplicationRecord
  belongs_to :user
  
  validates :event_name, presence: true
  validates :chouseisan_note, length: { maximum: 200 }
  validates :reference, length: { maximum: 200 }
  
end
