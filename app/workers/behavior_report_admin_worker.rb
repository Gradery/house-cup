class BehaviorReportAdminWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :behavior_report
  def perform(member_id, admin_id)
    # make sure staff exists
    if AdminUser.where(:id => admin_id).exists?
    	`mkdir #{Rails.root}/public/pdfs/#{@jid}`
    	current_admin = AdminUser.find(admin_id)
  		member = Member.find(member_id)
			# get PointAssignments
			@assignments = PointAssignment.where(:member_id => member_id).order("created_at ASC").all
			points_by_activity_graph_url = generate_points_by_activity(admin_id, member_id, @assignments)
  		best_worst_per_day_of_week_url = best_worst_per_day_of_week(admin_id, member_id, @assignments)
  		points_per_day_url = points_per_day(admin_id, member_id, @assignments)
  		# render the HTML a string, dump that into a PDF
  		#require Rails.root.to_s+"/apps/controllers/background_view_controller"
  		av = ActionView::Base.new()
  		av.view_paths = ActionController::Base.view_paths
  		# need these in case your view constructs any links or references any helper methods.
	    av.class_eval do
	      include Rails.application.routes.url_helpers
	      include ApplicationHelper
	    end
	    html = av.render(
	    	:template => "api/member_behavior_report_admin.html.erb",
	    	:layout => "layouts/api.html.erb",
	    	:locals => {
	    		:member => member,
	    		:points_by_activity_graph_url => points_by_activity_graph_url,
	    		:best_worst_per_day_of_week_url => best_worst_per_day_of_week_url,
	    		:points_per_day_url => points_per_day_url,
	    		:assignments => @assignments
	    	}
	    )
  		kit = PDFKit.new(html, page_size: "Letter")
   		kit.to_file("#{Rails.root}/public/pdfs/#{@jid}/Full Behavior Report - #{member.name} #{Date.today.strftime('%m-%d-%y')}.pdf")

  		# Send to the cloud
  		file = Rails.configuration.s3_bucket.files.create(
  			:key => "house_cup/development/Full Behavior Report - #{member.name} #{Date.today.strftime('%m-%d-%y')}.pdf",
  			:body => File.open("#{Rails.root}/public/pdfs/#{@jid}/Full Behavior Report - #{member.name} #{Date.today.strftime('%m-%d-%y')}.pdf"),
  			:public => true
  		)
  		# remove the folder will all the pdfs in it
  		`rm -R #{Rails.root}/public/pdfs/#{@jid}`
  		# send an email to the user with the download link
  		ReportMailer.email_admin(admin_id, member, file.public_url).deliver!
    end # else finish the job, it's not valid
  end

  private

  def generate_points_by_activity(admin_id, member_id, assignments)
  	# map the activities so we can count them
  	count = Hash.new
  	assignments.each do |a|
  		if a.custom_points == true # custom assignment
  			if count[a.custom_points_title].nil? # create
  				count[a.custom_points_title] = a.custom_points_amount.abs
  			else
  				count[a.custom_points_title] += a.custom_points_amount.abs
  			end
  		else # pre-set activity
  			if count[a.activity.name].nil? # create
  				count[a.activity.name] = a.activity.points.abs
  			else
  				count[a.activity.name] += a.activity.points.abs
  			end
  		end
  	end
  	# put this all into an image
  	g = Gruff::Pie.new(2000)
    g.title = "Percentage Of Total Points By Activity"
    count.each do |name, c|
      g.data(name, c)
    end
    g.theme = Gruff::Themes::GREYSCALE
    image_file_name = "1-"+DateTime.now.to_i.to_s+"-"+member_id.to_s+"-"+admin_id.to_s+".png"
    g.write("public/" + image_file_name)
    # save file to S3
    file = Rails.configuration.s3_bucket.files.create(
		:key => "house_cup/development/"+image_file_name,
		:body => File.open("public/" + image_file_name),
		:public => true
	)
	# delete the temp file
	File.delete("public/" + image_file_name)
	return file.public_url
  end

  def best_worst_per_day_of_week(admin_id, member_id, assignments)
	days_of_week = {
		"Monday" => 0,
		"Tuesday" => 0,
		"Wednesday" => 0,
		"Thursday" => 0,
		"Friday" => 0,
		"Saturday" => 0,
		"Sunday" => 0
	}
  	assignments.each do |a|
  		# get day of the week
  		dow = a.created_at.to_datetime.cwday
  		if dow == 1
  			day = "Monday"
  		elsif dow == 2
  			day = "Tuesday"
  		elsif dow == 3
  			day = "Wednesday"
  		elsif dow == 4
  			day = "Thursday"
  		elsif dow == 5
  			day = "Friday"
  		elsif dow == 6
  			day = "Saturday"
  		elsif dow == 7
  			day = "Sunday"
  		end
  		if a.custom_points == true # custom assignment
			days_of_week[day] += a.custom_points_amount
		else # pre-set activity
			days_of_week[day] += a.activity.points
		end
  	end
  	# turn this into a chart
  	# put this all into an image
	g = Gruff::Bar.new(2000)
    g.title = "Best/Worst Days Of The Week"
    days_of_week.each do |name, c|
      g.data(name, c)
    end
    g.theme = Gruff::Themes::GREYSCALE
    image_file_name = "2-"+DateTime.now.to_i.to_s+"-"+member_id.to_s+"-"+admin_id.to_s+".png"
    g.write("public/" + image_file_name)
    # save file to S3
    file = Rails.configuration.s3_bucket.files.create(
		:key => "house_cup/development/"+image_file_name,
		:body => File.open("public/" + image_file_name),
		:public => true
	)
	# delete the temp file
	File.delete("public/" + image_file_name)
	return file.public_url
  end

  def points_per_day(admin_id, member_id, assignments)
  	current_day = 0
  	current_month = 0
  	data = {}
  	assignments.each do |a|
  		if current_month != a.created_at.month || current_day != a.created_at.day
  			# create a new data entry
  			current_month = a.created_at.month
  			current_day = a.created_at.day
  			data[current_month.to_s + "/" + current_day.to_s] = 0
  		end
  		# add points to the data field
  		if a.custom_points == true # custom assignment
			data[current_month.to_s + "/" + current_day.to_s] += a.custom_points_amount
		else # pre-set activity
			data[current_month.to_s + "/" + current_day.to_s] += a.activity.points
		end
  	end
  	# turn this into a chart
  	# put this all into an image
	g = Gruff::Area.new(2000)
    g.title = "Points Per Day"
    current_month = 0 # reset this for the next set of tests
    i = 0
    totals = []
    data.each do |name, c|
      g.labels[i] = name
      totals.push(c)
      i += 1
    end
    g.data("points", totals)
    g.theme = Gruff::Themes::GREYSCALE
    image_file_name = "3-"+DateTime.now.to_i.to_s+"-"+member_id.to_s+"-"+admin_id.to_s+".png"
    g.write("public/" + image_file_name)
    # save file to S3
    file = Rails.configuration.s3_bucket.files.create(
		:key => "house_cup/development/"+image_file_name,
		:body => File.open("public/" + image_file_name),
		:public => true
	)
	# delete the temp file
	File.delete("public/" + image_file_name)
	return file.public_url
  end
end