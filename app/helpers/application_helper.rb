module ApplicationHelper

  def can_show_header?
    if params[:controller] == 'events' && params[:action] == 'show'
      false
    else
      true
    end
  end

  def body_class
    params[:controller] == 'events' && params[:action] == 'show' ? "full-width" : ''
  end

  def display_date(date)
    date.strftime("%m/%d/%Y") rescue 'MM/DD/YY'
  end

  def event_address(event)
    event.address.present? ? link_to(event.address, URI.encode("https://www.google.com/maps/search/#{event.address}"), target: '_blank', style: 'color: #4F89FB;') : "Not Available"
  end
end
