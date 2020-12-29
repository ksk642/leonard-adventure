extends Area


var entered_bodies = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	# do the disable thing
	pass


func can_hit_player():
	return not entered_bodies.empty()


func get_player():
	return entered_bodies.front()


func _on_attack_area_area_entered(area):
	pass # Replace with function body.


func _on_attack_area_body_entered(body):
	print(body.name, " entered att")
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


func _on_attack_area_body_exited(body):
	print(body.name, " exited att")
	if not body.is_a_parent_of(self) and body in entered_bodies:
		entered_bodies.erase(body)
