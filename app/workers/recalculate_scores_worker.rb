class RecalculateScoresWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :behavior_report

  def perform()
  	schools = School.all
  	schools.each do |school|
  		if Setting.where(:school => school, :key => "recalculate-scores-nightly").exists?
  			setting = Setting.where(:school => school, :key => "recalculate-scores-nightly").first
  			if setting.value.downcase == "true" # recalculate scores
  				# see if they have a cutoff date for points
  				if Setting.where(:school => school, :key => "recalculate-points-since").exists?
  					temp = Setting.where(:school => school, :key => "recalculate-points-since").first
  					cutoff_date = DateTime.strptime(temp.value, '%D')
  				else
  					cutoff_date = DateTime.now - 100.years
  				end
  				houses = House.where(:school => school).to_a
  				houses.each do |house|
  					points = 0
  					assignments = PointAssignment.where(:house => house).where("created_at > ?", cutoff_date)
  					assignments.find_each do |a|
  						if a.custom_points == true
  							points += a.custom_points_amount
  						else # Activity
  							points += a.activity.points
  						end
  					end
  					house.points = points
  					house.save!
  				end
  			end
  		end
  	end
  end

end