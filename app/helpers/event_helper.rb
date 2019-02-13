module EventHelper
  def display_date(date)
    date.strftime("%m/%d/%Y") rescue 'MM/DD/YY'
  end

  def get_qr_code(url, size)
    RQRCode::QRCode.new(url).to_img
                   .resize(size, size).to_data_url
  end

  def get_event_url(event)
    "#{request.base_url}/#{current_user.name.parameterize}/#{event.name.parameterize}"
  end

  def split_datetime(datetime)
    date_part = datetime.strftime('%Y/%m/%d') rescue ''
    time_part = datetime.strftime('%H:%M') rescue ''
    [date_part, time_part]
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

  def event_address
    @event.address.present? ? link_to(@event.address, URI.encode("https://www.google.co.in/maps/place/#{@event.address}"), target: '_blank', style: 'color: rgba(0, 0, 0, 0.8);') : nil
  end
end
