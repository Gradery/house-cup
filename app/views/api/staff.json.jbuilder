json.staff @staff do |s|
	json.id s.id
	json.name s.name
	json.email s.email
	json.house s.house.name
	json.grade s.grade
end