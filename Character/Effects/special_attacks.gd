extends Node

export var lv = 1
export var DAMAGE = 2
var attack = DAMAGE
export var MPcost = 0
export (String, "fire", "water", "lightning") var type
export var command = "aaa"
export var use_count = 0
export var locked = true
export var SPEED = 0.1
export var WAIT_TIME = 3
const EPS = 0.0001
export var height = 0

var direction = Vector3(0, 0, 0)

signal UNLOCKED

func unlock():
	locked = false
	emit_signal("UNLOCKED")


#func _ready():
#	pass
	#$"../Timer".start(WAIT_TIME)


#func is_equal(x: float, y: float):
#	return abs(x - y) < EPS


func _process(_delta):
	if not get_parent().get_node("AnimationPlayer").is_playing():
		print(get_parent())
		get_parent().queue_free()
		
	"""
	if not is_inside_tree():
		return
	var spec_att = get_parent()
	var current_direction = rad2deg(spec_att.rotation.y)
	if current_direction < 0:
		current_direction += 360
#    spec_att.global_translate(direction * SPEED)
#    print(spec_att.glosbal_transform.origin)
	if is_equal(current_direction, 0):
		spec_att.global_translate(Vector3(0, 0, SPEED))
	elif is_equal(current_direction, 45):
		spec_att.global_translate(Vector3(SPEED, 0, SPEED))
	elif is_equal(current_direction, 90):
		spec_att.global_translate(Vector3(SPEED, 0, 0))
	elif is_equal(current_direction, 135):
		spec_att.global_translate(Vector3(SPEED, 0, -SPEED))
	elif is_equal(current_direction, 180):
		spec_att.global_translate(Vector3(0, 0, -SPEED))
	elif is_equal(current_direction, 225):
		spec_att.global_translate(Vector3(-SPEED, 0, -SPEED))
	elif is_equal(current_direction, 270):
		spec_att.global_translate(Vector3(-SPEED, 0, 0))
	elif is_equal(current_direction, 315):
		spec_att.global_translate(Vector3(-SPEED, 0, SPEED))
	"""
	


#func _on_Timer_timeout():
#    print(get_parent().name)
#	get_parent().queue_free()


func area_collided(area):
	if area.name == "damage_area" and area.get_parent().name != "Leonard":
		get_parent().queue_free()
