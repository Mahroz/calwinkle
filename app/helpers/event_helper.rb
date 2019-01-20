module EventHelper
  def display_date(date)
    date.strftime("%m/%d/%Y") rescue 'MM/DD/YY'
  end

  def get_qr_code(url, size)
    # calendar_url(format: :ics, id: event.id)
    RQRCode::QRCode.new(url).to_img
                   .resize(size, size).to_data_url
  end

  def get_event_url(event)
    "#{request.base_url}/#{current_user.name.parameterize}/#{event.name.parameterize}"
  end

  def form_url
    if @event.persisted?
      event_url
    else
      event_preview_url
    end
  end
end
