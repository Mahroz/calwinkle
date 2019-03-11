namespace :live_db do
  task :generate_cal_for_users => :environment do
    
    begin
      User.all.each do |u|
        @event_data = u.events.not_cancelled.map{|e| e.cal_data}.flatten
        @base_url = Rails.env.production? ? 'https://www.calwinkle.com/' : 'http://localhost:3000'
        
        template = File.read("#{Rails.root}/app/views/events/calendar_js_template.html.erb")
        result = ERB.new(template).result(binding)
        File.open("#{Rails.root}/app/views/users/user_event_calendars/user_#{u.id}_calendar.html", 'w+') do |f|
          f.write result
        end
      end
    rescue Exception => e
      print e.message
    end
  end

end
