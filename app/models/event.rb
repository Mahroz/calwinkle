class Event < ApplicationRecord
  require 'icalendar'

  mount_uploader :main_picture, PictureUploader

  validates :name, presence: true, uniqueness: { scope: :user_id }

  belongs_to :user

  def start_on
    get_formatted_date_time(start_date, start_time)
  end

  def end_on
    get_formatted_date_time(end_date, end_time)
  end

  def calendar_url
    return '' if start_date.blank? || start_time.blank? || end_date.blank? || end_time.blank?

    start_dtime = start_date.to_datetime + start_time.seconds_since_midnight.seconds
    end_dtime = end_date.to_datetime + end_time.seconds_since_midnight.seconds
    cal = Icalendar::Calendar.new
    cal.event do |e|
      # Icalendar::Values::Date.new('20050428')
      e.dtstart     = start_dtime
      e.dtend       = end_dtime
      e.summary     = name
      e.description = description
      e.location = address || ''
      # e.ip_class    = "PRIVATE"
    end
    cal.publish
    cal.to_ical
  end

  private
  
  def get_formatted_date_time(date,time)
    date.strftime('%A, %d %b, %Y') + ' - ' + time.strftime('%l:%M %p') rescue 'N/A'
  end
end
