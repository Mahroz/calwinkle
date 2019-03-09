class Event < ApplicationRecord
  include EventCalandar

  mount_uploader :main_picture, PictureUploader
  mount_uploader :organizer_picture, PictureUploader

  validates :name, presence: true
  validates_presence_of :start_date, :start_time, :end_date, :end_time
  validate :start_end_date_time
  validate :name_uniqueness

  belongs_to :user
  has_one :event_report
  delegate :viewer_count, to: :event_report
  delegate :subscriber_count, to: :event_report

  after_create :create_event_report

  scope :not_cancelled, -> { where(is_cancel: false) }

  OCR_DONT_REPEAT = 'Do not repeat'.freeze
  OCR_DAILY = 'Daily'.freeze
  OCR_WEEKL_DAYS = 'Week Days'.freeze
  OCR_WEEKENDS = 'Weekends'.freeze
  OCR_MONTHLY = 'Monthly'.freeze
  OCR_YEARLY = 'Yearly'.freeze
  OCR_CUSTOM = 'Custom Days'.freeze

  enum occurance_type: [OCR_DONT_REPEAT, OCR_DAILY, OCR_WEEKL_DAYS,
                        OCR_WEEKENDS, OCR_MONTHLY, OCR_YEARLY]

  def formatted_start_time
    start_time.strftime('%I:%M %p') rescue '12:00 PM'
  end

  def formatted_end_time
    end_time.strftime('%I:%M %p') rescue '01:00 PM'
  end

  def start_on
    get_formatted_date_time(start_date, start_time)
  end

  def end_on
    get_formatted_date_time(end_date, end_time)
  end

  def calendar
    get_calendar(self)
  end

  def complete_url
    Rails.env.production? ? 'www.calwinkle.com' : 'localhost:3000' + event_url
  end

  def viewer_count_increment
    event_report.increment!(:viewer_count)
  end

  def subscriber_count_increment
    event_report.increment!(:subscriber_count)
  end
  private

  def start_end_date_time
    return if !start_date || !start_time || !end_date || !end_time
    if end_date < start_date
      errors.add(:base, I18n.t('errors.end_date_time'))
    elsif end_date == start_date && end_time <= start_time
      errors.add(:base, I18n.t('errors.end_date_time'))
    end
  end

  def name_uniqueness
    return if !name
    # if Event.where(name: name, user_id: user_id, is_cancel: false, end_date: Date.today..1.year.from_now ).count > 0
    #   errors.add(:base, I18n.t('errors.unique_name'))
    # end
  end

  def get_formatted_date_time(date,time)
    date.strftime('%A, %b %d %Y') + ' at ' + time.strftime('%l:%M %P') rescue 'N/A'
  end

  def create_event_report
    EventReport.create(event_id: id)
  end
end
