class Group < ApplicationRecord

  mount_uploader :image, GroupImageUploader

  belongs_to :user
  has_many :events, dependent: :destroy

  validates :name, uniqueness: { scope: :user_id }

  after_validation :set_group_url

  def set_group_url
    index = 0
    group_url_base = "/#{self.user.name.parameterize}/groups/#{self.name.parameterize}"
    url = group_url_base
    while Group.where("id != ? AND group_url = ? ", self.id.to_i, url).count > 0
      index += 1
      url = group_url_base + "-#{index}"
    end
    self.group_url = url
  end

  def complete_url
    Rails.env.production? ? 'https://www.calwinkle.com/' : 'http://localhost:3000/' + group_url
  end
end