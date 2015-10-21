class PageController < ApplicationController
	before_filter :authenticate_staff!, :only => [:add, :doadd, :students]

	def index
		@schools = School.all.to_a.sort_by{|h| h[:name]}
	end	

	def about
		@school = get_school
		if @school.nil?
			render status: 404
		end
	end

	def show
		@school = get_school
		if @school.nil?
			render status: 404
		else
			set_house_term()
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
		@school = get_school
		if @school.nil?
			render status: 404
		else
			# make sure school matches the staff
			if current_staff.school_id.to_i != @school.id
				render status: 401
			else
				@houses = House.where(:school_id => @school.id).to_a
				@activities = Activity.where(:school_id => @school.id).to_a
				if @houses.count % 2 == 0 #even
					@col_size_xs = 6
					@col_size_sm = 2
					@col_size_md = 2
				else #odd
					@col_size_xs = 4
					@col_size_sm = 4
					@col_size_md = 4
				end
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

			# see if we need to show the note section
			if Setting.where(:school => @school, :key => "show-note-section").exists?
				temp = Setting.where(:school => @school, :key => "show-note-section").first.value
				if temp.downcase == "true"
					@show_note = true
				else
					@show_note = false
				end
			else
				@show_note = false
			end

			# see if we need to show the assign to students section
			if Setting.where(:school => @school, :key => "track-student-points").exists?
				temp = Setting.where(:school => @school, :key => "track-student-points").first.value
				if temp.downcase == "true"
					@track_student = true
					# get all the grades a student can be in
					@grades = Setting.where(:school => @school, :key => "grades").first.value.split(",").delete_if{|a| a == "other"}
				else
					@track_student = false
				end
			else
				@track_student = false
			end

			#see if we need to show the options for entering custom points
			if Setting.where(:school => @school, :key => "custom-points").exists?
				temp = Setting.where(:school => @school, :key => "custom-points").first.value
				if temp.downcase == "true"
					@custom_points = true
				else
					@custom_points = false
				end
			else
				@custom_points = false
			end

			#see if we need to show the options for entering the same thing multiple times
			if Setting.where(:school => @school, :key => "multiple-assignments").exists?
				temp = Setting.where(:school => @school, :key => "multiple-assignments").first.value
				if temp.downcase == "true"
					@can_add_multiple = true
				else
					@can_add_multiple = false
				end
			else
				@can_add_multiple = false
			end
		end
	end

	def doadd
		@school = get_school
		if @school.nil?
			render html: "",status: 404
		else
			if params['custom_points'] == "true"
				can_add = SettingsHelper.can_add(params, @school, current_staff)
				if can_add == true
					if params['member_ids'].nil? # add to the house
						@house = House.where(:id => params['house']).first
						if @house.nil?
							render json: {error: "House ID is required"}, status: 401
						else
							p = PointAssignment.new
							p.staff = current_staff
							p.activity = nil
							p.custom_points = true
							p.custom_points_title = params['title']
							p.custom_points_amount = params['amount']
							p.house = @house
							p.note = params['note']
							#p.member_id = params['member_id'] if params['member_id'] != "undefined"
							p.save!
							# change the points in the house
							@house.points += params['amount'].to_i
							if @house.points < 0
								@house.points = 0
							end
							@house.save!
							render json: {success: true}
						end
					else
						params['member_ids'].each do |member|
							ap member
							m = Member.find(member.to_i)
							p = PointAssignment.new
							p.staff = current_staff
							p.activity = nil
							p.custom_points = true
							p.custom_points_title = params['title']
							p.custom_points_amount = params['amount']
							p.house = m.house
							p.note = params['note']
							p.member_id = member
							p.save!
							# change the points in the house
							m.house.points += params['amount'].to_i
							if m.house.points < 0
								m.house.points = 0
							end
							m.house.save!
						end
						render json: {success: true}
					end
				else
					handle_adding_error(can_add)
				end
			else
				@activity = Activity.where(id: params['activity']).first
				if @activity.nil?
					render json: {error: "Activity ID is required"}, status: 401
				else #we're good to set the points, check if we're rate limiting
					can_add = SettingsHelper.can_add(params, @school, current_staff)
					if can_add == true
						if params['member_ids'].nil? # add to the house
							@house = House.find(params['house'])
							if @house.nil?
								render json: {error: "House ID is required"}, status: 401
							else
								p = PointAssignment.new
								p.staff = current_staff
								p.activity = @activity
								p.house = @house
								p.note = params['note']
								p.member_id = params['member_id'] if params['member_id'] != "undefined"
								p.save!
								# change the points in the house
								@house.points += @activity.points
								if @house.points < 0
									@house.points = 0
								end
								@house.save!
								render json: {success: true}
							end
						else
							params['member_ids'].each do |member|
								ap member
								m = Member.find(member.to_i)
								p = PointAssignment.new
								p.staff = current_staff
								p.activity = @activity
								p.house = m.house
								p.note = params['note']
								p.member_id = member
								p.save!
								# change the points in the house
								m.house.points += @activity.points
								if m.house.points < 0
									m.house.points = 0
								end
								m.house.save!
								render json: {success: true}
							end
						end



						
					else # handle error
						handle_adding_error(can_add)
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
			# check house is in school
			if @house.school_id == @school.id
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

	def students
		@school = School.find(current_staff.school_id.to_i)
		@house = House.where(:id => params['house'].to_i).first
		ap @house
		if @house.nil? # get all students
			students = Member.where(:school => @school).all.to_a.sort_by{|a| a[:name]}
		else
			students = Member.where(:house => @house, school: @school).all.to_a.sort_by{|a| a[:name]}
		end
		render json: students
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

	def set_house_term
		if Setting.where(:school => @school, key: "house-term").exists?
			@house_term =  Setting.where(:school => @school, key: "house-term").first.value
		else
			@house_term = "House"
		end
	end

	def handle_adding_error(error)
		if error == "missing required note"
			render json: {error: "You must fill out the note field"}, status: 400
		elsif error == "missing member_ids"
			render json: {error: "You must assign point to at least one student"}, status: 400
		else # it's the number of minutes they have to wait
			render json: {error: "You must wait "+error.to_s+" more minutes before adding more points"}, status: 400
		end
	end
end