class ApiController < ApplicationController
	def houses
		if current_admin_user.nil?
			render json:{}, status: 400
		else
			houses = House.where(:school_id => current_admin_user.school_id).all
			render json: houses.sort_by{|h| h.name}
		end
	end

	def house_points_by_activity
		if current_admin_user.nil?
			render json:{}, status: 400
		else
			activities = Activity.where(:school_id => current_admin_user.school_id.to_s).all 
			text = Array.new
			activities.each do |a|
				text.push( {:label =>  a.name, :data => PointAssignment.where(:house_id => params["house_id"], :activity_id => a.id).count.to_s})
			end
			render json: {house: params['house_id'], data: text }
		end
	end

	def staff
		if current_admin_user.nil?
			render json:{}, status: 400
		else
			@staff = Staff.where(:school_id => current_admin_user.school_id.to_s).all.sort_by{|h| 
				if h.name.nil?
					h.email 
				else 
					h.name 
				end
			}
		end
	end

	def specific_staff
		if current_admin_user.nil?
			render json:{}, status: 400
		else
			if Staff.where(:id => params['id']).exists?
				@staff = Staff.find(params['id'])
			else
				render json: {error: "Not Found"}, status: 404
			end
		end
	end

	def staff_assignment_by_activity
		if current_admin_user.nil?
			render json:{}, status: 400
		else
			staff = Staff.where(:school_id => current_admin_user.school_id.to_s).all 
			activities = Activity.where(:school_id => current_admin_user.school_id.to_s).all 
			text = Array.new
			activities.each do |a|
				text.push({label: a.name, data: PointAssignment.where( :activity_id => a.id, :staff_id => params['staff_id']).count })
			end
			render json: {staff: params['staff_id'], data: text}
		end
	end

	def members
		if current_admin_user.nil?
			render json:{}, status: 400
		else
			@members = Member.includes(:house).where(:school_id => current_admin_user.school_id.to_s).all.sort_by{|h| 
				if h.name.nil?
					h.badge_id
				else
					h.name
				end
			}
		end
	end

	def top_members
		if current_admin_user.nil?
			render json:{}, status: 400
		else
			houses = House.where(:school => current_admin_user.school_id.to_s).all
			@hash = []
			houses.each do |house|
				members = [];
				Member.includes(:point_assignments).where(house: house).each do |m|
					sum = 0
					m.point_assignments.each do |p|
						if p.custom_points
							sum += p.custom_points_amount
						else
							sum += p.activity.points
						end
					end
					members.push({ "id" => m.id, "name" => m.name, "badge_id" => m.badge_id, "points" => sum })
				end
				members = members.sort_by{|h| h['points']}.reverse.slice(0,20)
				@hash.push({"house" => house.name, "members" => members})
			end
			ap @hash
			render "top_bottom"
		end
	end

	def bottom_members
		if current_admin_user.nil?
			render json:{}, status: 400
		else
			houses = House.where(:school => current_admin_user.school_id.to_s).all
			@hash = []
			houses.each do |house|
				members = [];
				Member.includes(:point_assignments).where(house: house).each do |m|
					sum = 0
					m.point_assignments.each do |p|
						if p.custom_points
							sum += p.custom_points_amount
						else
							sum += p.activity.points
						end
					end
					members.push({ "id" => m.id, "name" => m.name, "badge_id" => m.badge_id, "points" => sum })
				end
				members = members.sort_by{|h| h['points']}.slice(0,20)
				@hash.push({"house" => house.name, "members" => members})
			end
			ap @hash
			render "top_bottom"
		end
	end

	def houses
		if current_admin_user.nil?
			render json:{}, status: 400
		else
			houses = House.where(:school_id => current_admin_user.school_id.to_s).all 
			render json: houses.sort_by { |h| h.name}
		end
	end

	def top_points
		if current_admin_user.nil?
			render json:{}, status: 400
		else
			staff = Staff.includes(:point_assignments).where(:school_id => current_admin_user.school_id.to_s).all 
			text = Array.new
			staff.each do |s|
				sum = 0
				s.point_assignments.each do |p|
					if !p.custom_points
						sum = sum + p.activity.points if !p.activity.nil?
					else
						sum = sum + p.custom_points_amount
					end
				end
				text.push({label: s.email, data: sum})
			end
			render json: text
		end
	end

	def member_behavior_report
		if current_staff.nil?
			render json:{}, status: 400
		else
			BehaviorReportStaffWorker.perform_async(params['members'],current_staff.id)
			render json: {success: true}
		end
	end
end