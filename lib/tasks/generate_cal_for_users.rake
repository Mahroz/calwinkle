namespace :live_db do
  task :generate_cal_for_users => :environment do
    
    begin
      User.all.each do |u|
        u.set_events_calendar_data
      end
    rescue Exception => e
      print e.message
    end
  end

end
