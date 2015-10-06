class ApiController < ApplicationController
	def houses
		if current_admin_user.nil?
			render json:{}, status: 400
		else
			houses = House.where(:school_id => current_admin_user.school_id).all
			render json: houses 
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
			staff = Staff.where(:school_id => current_admin_user.school_id.to_s).all 
			render json: staff
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