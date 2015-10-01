task :create_secret do
	a = Rails.root
	`cp #{a}/config/secrets.yml.example #{a}/config/secrets.yml`
end