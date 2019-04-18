class Group < ApplicationRecord

  mount_uploader :image, GroupImageUploader

  belongs_to :user
  has_many :events, dependent: :destroy

  validates :name, uniqueness: { scope: :user_id }
  
end
