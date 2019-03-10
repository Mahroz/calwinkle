require 'yaml/store'
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, uniqueness: true

  has_many :events

  def set_events_calendar_data
    @event_data = self.events.not_cancelled.map{|e| e.cal_data}.flatten
    @base_url = Rails.env.production? ? 'https://www.calwinkle.com/' : 'http://localhost:3000'
    
    template = File.read("#{Rails.root}/app/views/events/calendar_js_template.html.erb")
    result = ERB.new(template).result(binding)
    File.open("app/views/users/user_event_calendars/user_#{self.id}_calendar.html", 'w+') do |f|
      f.write result
    end
  end
end
