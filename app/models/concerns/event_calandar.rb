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

    tzid = event.time_zone
    tz = TZInfo::Timezone.get tzid
    timezone = tz.ical_timezone event_start
    cal.add_timezone timezone

    cal.event do |e|
      e.dtstart     = Icalendar::Values::DateTime.new event_start, 'tzid' => tzid
      e.dtend       = Icalendar::Values::DateTime.new event_end, 'tzid' => tzid
      e.summary     = name
      e.description = description
      e.location    = address || ''
      e.status      = 'CANCELLED' if event.is_cancel?
    end
    cal.publish
    cal.to_ical
  end
end
