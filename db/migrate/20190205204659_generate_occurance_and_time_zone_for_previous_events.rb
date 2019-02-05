class GenerateOccuranceAndTimeZoneForPreviousEvents < ActiveRecord::Migration[5.2]
  def change
  	Event.all.each do |e|
		e.occurance_type = 0
		e.occurance_rule = ""
		e.time_zone = "GMT"
		e.save!
	end
  end
end
