class EventCalendar < ApplicationRecord

  belongs_to :user
  validates_presence_of :calendar_html
end
