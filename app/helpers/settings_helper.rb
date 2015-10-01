module SettingsHelper
	def self.can_add(params, school, staff)
		# wrapper function to handle all of our permissions for if we can add points in a given situation
		value = check_rate_limit(params, school, staff)
		return value if value != true
		value = check_note_required(params, school)
		return value if value != true
		value = check_student_points(params, school)
		return value
	end

	private

	def self.check_rate_limit(params, school, staff)
		if Setting.where(:key => "rate-limit", :school => school).exists? && 
		   Setting.where(:key => "rate-limit", :school => school).first.value.downcase == "true"
			puts "checking rate limit"
			if params['amount'].to_i > 0 #positive points
				check_minutes = Setting.where(:key => "rate-limit-positive-reset-minutes", :school => school).first.value.to_i
				check_max_points = Setting.where(:key => "rate-limit-max-positive-points", :school => school).first.value.to_i
			else
				check_minutes = Setting.where(:key => "rate-limit-negative-reset-minutes", :school => school).first.value.to_i
				check_max_points = Setting.where(:key => "rate-limit-max-negative-points", :school => school).first.value.to_i
			end
			# get all the submissions by this user in the last check_minutes minutes
			assignments = PointAssignment.where(:staff => staff).where("created_at >= ?", DateTime.now - check_minutes.minutes).all
			# go through these and sum up the points in them if they are on the correct side of 0
			total_points = 0
			assignments.each do |a|
				if params['amount'].to_i > 0 #positive points only
					if a.activity.nil? #custom points
						total_points += a.custom_points_amount if a.custom_points_amount > 0
					else
						total_points += a.activity.points if a.activity.points > 0
					end
				else #negative points only
					if a.activity.nil?
						total_points += a.custom_points_amount if a.custom_points_amount < 0
					else
						total_points += a.activity.points if a.activity.points < 0
					end
				end
			end
			if (total_points + params['amount'].to_i).abs > check_max_points.abs #can't add
				return check_minutes
			else
				return true
			end 
		else #rate limit var not set, assume it's false
			return true
		end
	end

	def self.check_note_required(params, school)
		# check if the note is required, and whether it exists
		if Setting.where(:school => school, :key => "note-required").exists?
			puts "checking note required"
			setting = Setting.where(:school => school, :key => "note-required").first.value
			if setting.downcase == "true" #check if note is set
				if params['note'].nil? || params['note'] == "undefined" || params['note'] == ""
					return "missing required note" # not not filled in correctly
				else # note is set
					return true
					
				end
			else # not required, clean it up if it's not set
				params['note'] = nil if params['note'] == "undefined"
				return true
			end
		else
			return true
		end
	end

	def self.check_student_points(params, school)
		# see if we require they have the member_id set
		if Setting.where(:school => school, :key => "require-student-points").exists?
			puts "checking if student points are required and set"
			setting = Setting.where(:school => school, :key => "require-student-points").first.value
			if setting.downcase == "true"
				# check the member id
				if params['member_ids'].nil? || params['member_ids'] == []
					return "missing member_ids"
				else
					return true
				end
			else # doesn't matter
				return true
			end
		else
			return true
		end
	end
end