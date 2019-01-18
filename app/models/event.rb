class Event < ApplicationRecord
  mount_uploader :main_picture, PictureUploader

  validates :name, presence: true

  def start_on
    start_date.strftime("%m/%d/%y") + ' ' + start_time.strftime("%H:%M")
  end

  def end_on
    end_date.strftime("%m/%d/%y") + ' ' + end_time.strftime("%H:%M")
  end
end