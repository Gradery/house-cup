json.members @members do |member|
	json.id member.id
	json.name member.name
	json.email member.email
	json.badge_id member.badge_id
	json.house member.house.name
	json.grade member.grade
	json.badge_id member.badge_id
end