module EventHelper
  def display_date(date)
    date.strftime("%m/%d/%y") rescue 'MM/DD/YY'
  end

  def get_qr_code(size)
    RQRCode::QRCode.new("http://codingricky.com").to_img.resize(size, size).to_data_url
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
