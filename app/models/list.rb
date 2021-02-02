class List < ApplicationRecord
  attr_accessor :img_url

  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true, length: { maximum: 128 }
  validates :profile, length: { maximum: 100 }
  mount_uploader :image, ListImageUploader
end
