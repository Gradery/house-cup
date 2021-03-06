class BehaviorReportStaffWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :behavior_report
  def perform(members, staff_id)
    # make sure staff exists
    if Staff.where(:id => staff_id).exists?
    	pdfs = []
    	`mkdir #{Rails.root.to_s}/tmp/#{@jid}`
    	current_staff = Staff.find(staff_id)
    	members.each do |member_id|
    		member = Member.find(member_id)
			 # get PointAssignments
			 @assignments = PointAssignment.where(:staff => current_staff, :member_id => member_id).order("created_at ASC").all
			 points_by_activity_graph_url = generate_points_by_activity(staff_id, member_id, @assignments)
    	 best_worst_per_day_of_week_url = best_worst_per_day_of_week(staff_id, member_id, @assignments)
    		points_per_day_url = points_per_day(staff_id, member_id, @assignments)
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
		    	:template => "api/member_behavior_report.html.erb",
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
     		kit.to_file("#{Rails.root.to_s}/tmp/#{@jid}/Behavior_Report_#{member.name.gsub(',','').gsub(" ","_")}_#{Date.today.strftime('%m-%d-%y')}.pdf")
			  pdfs.push("#{Rails.root.to_s}/tmp/#{@jid}/Behavior_Report_#{member.name.gsub(',','').gsub(" ","_")}_#{Date.today.strftime('%m-%d-%y')}.pdf")
    	end
    	# combine all pdfs into a zip file
    	require 'zip'
    	zipfile_name = "#{Rails.root.to_s}/tmp/#{@jid}/behavior_reports_#{jid}.zip"

  		Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
  		  pdfs.each do |file_path|
  		    # Two arguments:
  		    # - The name of the file as it will appear in the archive
  		    # - The original file, including the path to find it
  		    zipfile.add(file_path.split("/").last, file_path)
  		  end
  		end
  		# Send to the cloud
      if !Rails.env.test?
    		file = Rails.configuration.s3_bucket.files.create(
    			:key => "house_cup/#{Rails.env}/behavior_reports_#{jid}.zip",
    			:body => File.open(zipfile_name),
    			:public => true
    		)
    		# remove the folder will all the pdfs in it
    		`rm -R #{Rails.root.to_s}/tmp/#{@jid}`
    		# send an email to the user with the download link
    		ReportMailer.email_staff(staff_id, file.public_url).deliver!
      end
    end # else finish the job, it's not valid
  end

  private

  def generate_points_by_activity(staff_id, member_id, assignments)
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
    g.theme = Gruff::Themes::GREYSCALE
    g.replace_colors([
      "#ee4035",
      "#f37736",
      "#fdf498",
      "#7bc043",
      "#0392cf",
      "#9400D3",
      "#4B0082",
      "#FF0000",
      "#FF7F00",
      "#FFFF00",
      "#00FF00",
      "#0000FF"
    ])
    g.title = "Percentage Of Total Points By Activity"
    count.each do |name, c|
      g.data(name, c)
    end
    image_file_name = "1-"+DateTime.now.to_i.to_s+"-"+member_id.to_s+"-"+staff_id.to_s+".png"
    g.write("#{Rails.root.to_s}/tmp/" + image_file_name)
    # save file to S3
    if !Rails.env.test?
      file = Rails.configuration.s3_bucket.files.create(
    		:key => "house_cup/#{Rails.env}/"+image_file_name,
    		:body => File.open("#{Rails.root.to_s}/tmp/" + image_file_name),
    		:public => true
    	)
    	# delete the temp file
    	File.delete("#{Rails.root.to_s}/tmp/" + image_file_name)
    	return file.public_url
    else
      return "http://placehold.it/350x150"
    end
  end

  def best_worst_per_day_of_week(staff_id, member_id, assignments)
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
    g.theme = Gruff::Themes::GREYSCALE
    g.replace_colors([
      "#ee4035",
      "#f37736",
      "#fdf498",
      "#7bc043",
      "#0392cf",
      "#9400D3",
      "#4B0082",
      "#FF0000",
      "#FF7F00",
      "#FFFF00",
      "#00FF00",
      "#0000FF"
    ])
    g.title = "Best/Worst Days Of The Week"
    days_of_week.each do |name, c|
      g.data(name, c)
    end
    image_file_name = "2-"+DateTime.now.to_i.to_s+"-"+member_id.to_s+"-"+staff_id.to_s+".png"
    g.write("#{Rails.root.to_s}/tmp/" + image_file_name)
    # save file to S3
    if !Rails.env.test?
      file = Rails.configuration.s3_bucket.files.create(
    		:key => "house_cup/#{Rails.env}/"+image_file_name,
    		:body => File.open("#{Rails.root.to_s}/tmp/" + image_file_name),
    		:public => true
    	)
    	# delete the temp file
      File.delete("#{Rails.root.to_s}/tmp/" + image_file_name)
    	return file.public_url
    else
      return "http://placehold.it/350x150"
    end
  end

  def points_per_day(staff_id, member_id, assignments)
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
    g.theme = Gruff::Themes::GREYSCALE
    g.replace_colors([
      "#ee4035",
      "#f37736",
      "#fdf498",
      "#7bc043",
      "#0392cf",
      "#9400D3",
      "#4B0082",
      "#FF0000",
      "#FF7F00",
      "#FFFF00",
      "#00FF00",
      "#0000FF"
    ])
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
    image_file_name = "3-"+DateTime.now.to_i.to_s+"-"+member_id.to_s+"-"+staff_id.to_s+".png"
    g.write("#{Rails.root.to_s}/tmp/" + image_file_name)
    # save file to S3
    if !Rails.env.test?
      file = Rails.configuration.s3_bucket.files.create(
    		:key => "house_cup/#{Rails.env}/"+image_file_name,
    		:body => File.open("#{Rails.root.to_s}/tmp/" + image_file_name),
    		:public => true
    	)
    	# delete the temp file
    	File.delete("#{Rails.root.to_s}/tmp/" + image_file_name)
    	return file.public_url
    else
      return "http://placehold.it/350x150"
    end
  end
end