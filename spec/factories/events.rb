FactoryBot.define do
  factory :event do
    user_id { 1 }
    event_name { "イベントA" }
    event_status  { 0 }
    chouseisan_check { true }    
  end
end
