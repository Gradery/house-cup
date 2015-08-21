class PageController < ApplicationController

	def index
		@schools = School.all.to_a.sort_by{|h| h[:name]}
	end	

	def about
		@school = get_school
		if @school.nil?
			raise ActionController::RoutingError.new('Not Found')
		end
	end

	def show
		@school = get_school
		if @school.nil?
			raise ActionController::RoutingError.new('Not Found')
		else
			# get the houses
			@houses = House.where(:school_id => @school.id).to_a
			# sort the houses
			@houses = @houses.sort_by {|h| h[:name].downcase }
			#find the highest score
			@max_score = 1
			@houses.each do |h|
				if h.points > @max_score
					@max_score = h.points
				end
			end
			@max_score += 10
			puts @max_score
			# Get the setting to whether to show house names in text or not
			if Setting.where(:school => @school, :key => "show-house-text-names").exists?
				temp = Setting.where(:school => @school, :key => "show-house-text-names").first.value
				if temp.downcase == "true"
					@showHouseTextNames = true
				else
					@showHouseTextNames = false
				end
			else
				@showHouseTextNames = false
			end
		end
	end

	def add
		authenticate_staff!
		@school = get_school
		if @school.nil?
			raise ActionController::RoutingError.new('Not Found')
		else
			# make sure school matches the staff
			if current_staff.school_id.to_i != @school.id
				raise ActionController::RoutingError.new('Not Authorized')
			else
				@houses = House.where(:school_id => @school.id).to_a
				@activities = Activity.where(:school_id => @school.id).to_a
				@col_size = 6
			end

			# Get the setting to whether to show house names in text or not
			if Setting.where(:school => @school, :key => "show-house-text-names").exists?
				temp = Setting.where(:school => @school, :key => "show-house-text-names").first.value
				if temp.downcase == "true"
					@showHouseTextNames = true
				else
					@showHouseTextNames = false
				end
			else
				@showHouseTextNames = false
			end
		end
	end

	def doadd
		authenticate_staff!
		@school = get_school
		if @school.nil?
			raise ActionController::RoutingError.new('Not Found')
		else
			@house = House.find(params['house'])
			if @house.nil?
				render json: {error: "House ID is required"}, status: 401
			else
				@activity = Activity.find(params['activity'])
				if @activity.nil?
					render json: {error: "Activity ID is required"}, status: 401
				else #we're good to set the points, check if we're rate limiting
					can_add = false
					if Setting.where(:key => "rate-limit", :school => @school).exists? && 
					   Setting.where(:key => "rate-limit", :school => @school).first.value.downcase == "true"
						if @activity.points > 0 #positive points
							check_minutes = Setting.where(:key => "rate-limit-positive-reset-minutes", :school => @school).first.value.to_i
							check_max_points = Setting.where(:key => "rate-limit-max-positive-points", :school => @school).first.value.to_i
						else
							check_minutes = Setting.where(:key => "rate-limit-negative-reset-minutes", :school => @school).first.value.to_i
							check_max_points = Setting.where(:key => "rate-limit-max-negative-points", :school => @school).first.value.to_i
						end
						# get all the submissions by this user in the last check_minutes minutes
						assignments = PointAssignment.where(:staff => current_staff).where("created_at >= ?", DateTime.now - check_minutes.minutes).all
						# go through these and sum up the points in them if they are on the correct side of 0
						total_points = 0
						assignments.each do |a|
							total_points += a.activity.points
						end
						if (total_points + @activity.points).abs >= check_max_points.abs #can't add
							can_add = false
						else
							can_add = true
						end 
					else #rate limit var not set, assume it's false
						can_add = true
					end
					if can_add
						p = PointAssignment.new
						p.staff = current_staff
						p.activity = @activity
						p.house = @house
						p.save!
						# change the points in the house
						@house.points += @activity.points
						@house.save!
						render json: {success: true}
					else
						render json: {error: "You must wait "+check_minutes.to_s+" more minutes before adding more points"}, status: 400
					end
				end
			end
		end
	end

	def invite
		#get the house based on the id passed in
		@house = House.find(params['id'])
		if @house.nil?
			raise ActionController::RoutingError.new('Not Found')
		end
	end

	def doinvite
		@school = get_school
		if @school.nil?
			render json: {error: "school not found"}, status: 404
		else
			@house = House.find(params['id'])
			if @house.nil?
				render json: {error: "house not found"}, status: 404
			else
				# check house is in school
				if @house.school_id = @school.id
					# create member
					m = Member.new
					m.school = @school
					m.house = @house
					m.badge_id = params['student_id']
					m.name = params['name']
					m.save!
					render json: {success: true}
				else
					render json: {error: "house is not in listed school"}, status: 401
				end
			end
		end
	end

	def create_invite
		@school = get_school
		if @school.nil?
			raise ActionController::RoutingError.new('Not Found')
		end
	end

	def do_create_invite
		@school = get_school
		if @school.nil?
			raise ActionController::RoutingError.new('Not Found')
		else
			@houses = House.where(:school_id => @school.id).to_a
			max_houses = @houses.count
			@codes = Array.new
			current_house = 0
			o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
			i = 0
			while i < params['amount'].to_i do
				ap i
				random_string = (0...50).map { o[rand(o.length)] }.join
				qr = RQRCode::QRCode.new( request.base_url + "/" + @school.url + "/house/" + @houses[current_house]["id"].to_s + "?noise=" + random_string, :size => 9, :level => :h )
				@codes.push(qr.to_img)
				if current_house == max_houses-1
					current_house = 0
				else
					current_house = current_house + 1
				end
				i = i + 1
			end

		end
	end

	def stylesheet
		@school = get_school

		# see if they branded their site
		if Setting.where(:school => @school, :key => "background-color").exists?
			@backgroundColor = Setting.where(:school => @school, :key => "background-color").first.value
		else
			@backgroundColor = "#FFF"
		end
		if Setting.where(:school => @school, :key => "navbar-foreground-color").exists?
			@foregroundColor = Setting.where(:school => @school, :key => "navbar-foreground-color").first.value
		else
			@foregroundColor = "#000"
		end
		if Setting.where(:school => @school, :key => "button-color").exists?
			@buttonColor = Setting.where(:school => @school, :key => "button-color").first.value
		else
			@buttonColor = "#EB9939"
		end
		if Setting.where(:school => @school, :key => "navbar-background-color").exists?
			@navbarBackgroundColor = Setting.where(:school => @school, :key => "navbar-background-color").first.value
		else
			@navbarBackgroundColor = "#BDDFCA"
		end
		if Setting.where(:school => @school, :key => "text-color").exists?
			@textColor = Setting.where(:school => @school, :key => "text-color").first.value
		else
			@textColor = "#000"
		end


		filename = 'stylesheet.css'

	    extname = File.extname(filename)[1..-1]
	    mime_type = Mime::Type.lookup_by_extension(extname)
	    content_type = mime_type.to_s unless mime_type.nil?

	    headers['Content-Type'] = content_type
	    render :layout => false
	end

	def get_school
		if !params['school'].nil?
			if School.where(:url => params['school'].downcase).exists?
				return School.where(:url => params['school']).first
			else
				return nil
			end
		end
	end
end