require 'icalendar'
require 'icalendar/tzinfo'

# Implementation of iCalandar Configuration
module EventCalandar
  def get_calendar(event)
    event_start = event.start_date.to_datetime +
                  event.start_time.seconds_since_midnight.seconds
    event_end = event.end_date.to_datetime +
                event.end_time.seconds_since_midnight.seconds
    cal = Icalendar::Calendar.new
    cal.append_custom_property("X-WR-CALNAME","#{name} - CalWinkle")
    cal.append_custom_property("NAME","#{name} - CalWinkle")
    tzid = event.time_zone
    tz = TZInfo::Timezone.get tzid
    timezone = tz.ical_timezone event_start
    cal.add_timezone timezone

    cal.event do |e|
      e.dtstart     = Icalendar::Values::DateTime.new event_start, 'tzid' => tzid
      e.dtend       = Icalendar::Values::DateTime.new event_end, 'tzid' => tzid
      e.summary     = name
      e.summary     = "Cancelled - " + name if event.is_cancel?
      e.description = "#{description}<br><br>Event Details:<br>#{complete_url}"
      e.location    = address || ''
      # e.status      = 'CANCELLED' if event.is_cancel?
      e.rrule       = occurance_rule unless occurance_rule.blank?
      e.alarm do |a|
        a.action  = "DISPLAY"
        a.summary = "30 minutes before #{name}"
        a.description = description
        a.trigger = "-PT30M" # 30 Mins before
      end
      e.alarm do |a|
        a.action  = "DISPLAY"
        a.summary = "5 minutes before #{name}"
        a.description = description
        a.trigger = "-PT5M" # 15 Mins before
      end
    end
    cal.publish
    cal.to_ical
  end
end
