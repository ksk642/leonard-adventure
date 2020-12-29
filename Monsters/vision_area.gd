extends Area


var entered_bodies = []


func can_see_player():
	return not entered_bodies.empty()


func get_player():
	if entered_bodies.empty():
		return null
	else:
		return entered_bodies


func _on_vision_area_body_entered(body):
	print(body.name, " entered vision")
	if "GridMap" in body.name:
		return
	if "StaticBody" in body.name:
		return
	if $"../stats".is_pet:
		if body.name == "Leonard":
			return
		if not body.is_a_parent_of(self):
			entered_bodies.append(body)
	else:
		if not body.is_a_parent_of(self):
			entered_bodies.append(body)
		


func _on_vision_area_body_exited(body):
	print(body.name, " exited vision")
	if body in entered_bodies:
		entered_bodies.erase(body)
#	if not body.is_a_parent_of(self) and body in entered_bodies:
#		entered_bodies.erase(body)
