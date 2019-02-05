class GenerateEventReportForExistingEvents < ActiveRecord::Migration[5.2]
  def change
	Event.all.each do |e|
		EventReport.create!(event_id: e.id)
	end
  end
end
