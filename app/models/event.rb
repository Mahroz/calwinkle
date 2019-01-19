class Event < ApplicationRecord
  require 'icalendar'

  mount_uploader :main_picture, PictureUploader

  validates :name, presence: true

  belongs_to :user

  def start_on
    start_date.strftime('%m/%d/%y') + ' ' + start_time.strftime('%H:%M') rescue 'MM/DD/YY HH:MM'
  end

  def end_on
    end_date.strftime('%m/%d/%y') + ' ' + end_time.strftime('%H:%M') rescue 'MM/DD/YY HH:MM'
  end

  def calendar_url
    
  end
end
