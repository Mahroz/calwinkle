module EventHelper
  

  def get_qr_code(url, size)
    RQRCode::QRCode.new(url).to_img
                   .resize(size, size).to_data_url
  end

  

  def split_datetime(datetime)
    date_part = datetime.strftime('%Y/%m/%d') rescue ''
    time_part = datetime.strftime('%H:%M') rescue ''
    [date_part, time_part]
  end

  def get_month_week(date_or_time, start_day = :sunday)

    date = date_or_time.to_date
    week_start_format = start_day == :sunday ? '%U' : '%W'

    month_week_start = Date.new(date.year, date.month, 1)
    month_week_start_num = month_week_start.strftime(week_start_format).to_i
    month_week_start_num += 1 if month_week_start.wday > 4 # Skip first week if doesn't contain a Thursday

    month_week_index = date.strftime(week_start_format).to_i - month_week_start_num
    month_week_index + 1 # Add 1 so that first week is 1 and not 0
  end

  def monthly_sub_type_options(event_date)
    event_date = event_date.present? ? Date.parse(event_date.to_s) : Date.today
    ["Monthly on day #{event_date.day}", "Monthly on #{get_month_week(event_date).ordinalize} #{event_date.strftime('%A')}"]
  end
  
  def android_device?
    user_agent = request.headers["HTTP_USER_AGENT"]
    user_agent.present? && (user_agent =~ /\b(Android)\b/i).present?
  end

  def apple_device?
    user_agent = request.headers["HTTP_USER_AGENT"]
    user_agent.present? && (user_agent =~ /\b(iPhone|iPad)\b/i).present?
  end

  def format_date(date)
    Date.strptime(date, '%m/%d/%Y').strftime('%Y-%m-%d')
  end

  def form_url
    if @event.persisted?
      event_url
    else
      event_preview_url
    end
  end

  def user_events_for_calendar
    non_custom_occurance_types = ['daily', 'weekly', 'weekends']
    current_user.events.each_with_object([]) do |e, a|
    end
  end


  # def event_address
  #   @event.address.present? ? link_to(@event.address, URI.encode("https://www.google.com/maps/search/#{@event.address}"), target: '_blank', style: 'color: #4F89FB;') : "Not Available"
  # end

  def week_days
    ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat']
  end
end
