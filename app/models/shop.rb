class Shop < ApplicationRecord
  belongs_to :event
  
  VALID_URL_REGEX = /(\A\z)|(\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\z)/ix
  validates :shop_name, presence: true
  validates :shop_url, presence: true, length: { maximum: 200 }, format: { with: VALID_URL_REGEX }
  validates :remark, length: { maximum: 200 }

end
