class Event < ApplicationRecord
  include EventCalandar

  mount_uploader :main_picture, PictureUploader

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates_presence_of :start_date, :start_time, :end_date, :end_time
  validate :start_end_date_time

  belongs_to :user

  scope :not_cancelled, -> { where(is_cancel: false) }

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

  def viewer_count_increment
    increment!(:viewer_count)
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

  def get_formatted_date_time(date,time)
    date.strftime('%A, %d %b, %Y') + ' - ' + time.strftime('%l:%M %p') rescue 'N/A'
  end
end
