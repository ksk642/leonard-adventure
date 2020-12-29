extends KinematicBody


const SPEED = 3
const TELEPORT_DIST = 5
const RUN_SPEED = 3
const ANIMATION_DELTA = 0.1
var punch_count = 0
var current_y_angle = 0
var input_listen = true
var idling = true

var GRAVITY = -10

var rnd = RandomNumberGenerator.new()


onready var spell_list = ["a", "s", "d", "q", "w", "e", "z", "x", "c"]
#onready var spell_list = ["awc", "zxdx", "scxqs", "sez", "ezcw", "asdqa", "dqa", "sdcq", "zeedz"]
onready var spell_node_pos = []
onready var spell_inst = [fire1, fire2, fire3, lightning1, lightning2, lightning3, water1, water2, water3]

const fire1 = "res://Spells/Fire1.tscn"
const fire2 = "res://Spells/Fire2.tscn"
const fire3 = "res://Spells/Fire3.tscn"

const lightning1 = "res://Spells/Lightning1.tscn"
const lightning2 = "res://Spells/Lightning2.tscn"
const lightning3 = "res://Spells/Lightning3.tscn"

const water1 = "res://Spells/Water1.tscn"
const water2 = "res://Spells/Water2.tscn"
const water3 = "res://Spells/Water3.tscn"

"""
func create_spell_list():
	var spell_command = ""
	var node_pos = 0
	for node in get_children():
		if "Spell" in node.name:
			if not node.get_node("stats").locked:
				spell_command = node.get_node("stats").command
				node_pos = node.get_position_in_parent()
				spell_node_name.append(node.name)
				spell_list.append(spell_command)
				spell_node_pos.append(node_pos)
				for child_node in node.get_children():
					print(child_node)
					if "Spatial" in child_node.name:
						child_node.get_node("my_damage_area").get_node("CollisionShape").disabled = true
"""

func _on_LineEdit_MAGIC():
	var spell_command = $LineEdit.activate
	var spell_pos = spell_list.find(spell_command)
	var spell_dir_name = spell_inst[spell_pos]
	special_attack(spell_dir_name)
	
	

	#get_child(node_pos).$AnimationPlayer.play("special")
	#get_node(node_name).get_node("my_damage_area").get_node("CollisionShape").disabled = false
	#get_node(node_name).get_node("AnimationPlayer").play("special")
	#Timer.start(get_node(node_name).get_node("AnimationPlayer").current_animation_length)
	
"""
func _on_stats_UNLOCKED():
	create_spell_list()
"""


#func _ready():
#	create_spell_list()


func character_move(target_y_angle, x, z):
	if target_y_angle < current_y_angle:
		target_y_angle += 360
	$Armature.rotate_y(deg2rad(target_y_angle - current_y_angle))
	current_y_angle = target_y_angle
	if current_y_angle >= 360:
		current_y_angle -= 360
	var k = 1
	if x != 0 and z != 0:
		k = 0.7071
		pass
	if Input.is_action_pressed("run"):
		$AnimationPlayer.play("Run")
		move_and_slide(Vector3(x * RUN_SPEED * k, 0, z * RUN_SPEED * k))
	else:
		$AnimationPlayer.play("Walk")
		move_and_slide(Vector3(x * k, 0, z * k))


func special_attack(dirname):
	var sphe1 = load(dirname).instance()
	var stat_node = sphe1.get_node("stats")
	var mp_need = stat_node.MPcost
	var mp_left = $Armature/stats.MP
	if mp_need > mp_left:
		print("dont have enough mp!")
		return
	$Armature/stats.deltaMP(mp_need)
#    print(get_parent().name)
	get_parent().add_child(sphe1)
#    sphe1.global_scale(Vector3(0.2, 0.2, 0.2))
	sphe1.rotate_y(deg2rad(current_y_angle))
	sphe1.global_transform.origin = global_transform.origin # + Vector3(0, sphe1.get_node("stats").height, 0)
	print(stat_node.DAMAGE)
	
	"""Working, when this is turned off"""
	#input_listen = false
	
	var effect_name = ["Ultimate", "Heal"]
	var rnum = rnd.randi_range(0, 1)
	#$Timer3.start($AnimationPlayer.get_animation(effect_name[rnum]).length / 4 - ANIMATION_DELTA)
	$AnimationPlayer.play(effect_name[rnum], -1, 4)


func summon():
	var pet_collection = get_parent().get_node("pets").get_children()
	if pet_collection == null:
		return
#    var target = Vector3(0, 0, 0)
#    print(current_y_angle)
#    if current_y_angle == 0:
#        target.z = TELEPORT_DIST
#    elif current_y_angle == 45:
#        target.x = TELEPORT_DIST
#        target.z = TELEPORT_DIST
#    elif current_y_angle == 90:
#        target.x = TELEPORT_DIST
#    elif current_y_angle == 135:
#        target.x = TELEPORT_DIST
#        target.z = TELEPORT_DIST
#    elif current_y_angle == 180:
#        target.z = -TELEPORT_DIST
#    elif current_y_angle == 225:
#        target.x = -TELEPORT_DIST
#        target.z = -TELEPORT_DIST
#    elif current_y_angle == 270:
#        target.x = -TELEPORT_DIST
#    elif current_y_angle == 315:
#        target.x = -TELEPORT_DIST
#        target.z = TELEPORT_DIST
#    print(transform.origin)
#    print(target)
	input_listen = false
	$AnimationPlayer.play("Summon")
	$Timer.start($AnimationPlayer.get_animation("Summon").length - ANIMATION_DELTA)
	for pet in pet_collection:
		var target = (transform.origin - pet.transform.origin) + transform.origin
#        pet.translate(target)
		pet.transform.origin = target
#        print(target)


func _physics_process(delta):
	# gravity
	move_and_slide(Vector3(0, GRAVITY, 0))
	
#    if $Armature/my_damage_area/CollisionShape.disabled:
#        $Armature/my_damage_area/CollisionShape.disabled = false
#    else:
#        $Armature/my_damage_area/CollisionShape.disabled = true
	#print($Armature/my_damage_area/CollisionShape.translation)

	idling = false
	if not input_listen:
		return
	$Armature/my_damage_area/CollisionShape.translation = Vector3(0, 0, 0)
	if Input.is_action_just_pressed("kamehameha"):
		special_attack("lightning1")
#        kamehameha()
	elif Input.is_action_just_pressed("summon"):
		summon()
	elif Input.is_action_just_pressed("normal_attack"):
#        print("!?")
		punch_count += 1
		input_listen = false
		if punch_count < 3:
			$AnimationPlayer.play("Punch", -1, 2)
			$Timer.start($AnimationPlayer.get_animation("Punch").length / 2)
		else:
			punch_count = 0
			$AnimationPlayer.play("Kick", -1, 2)
			$Timer.start($AnimationPlayer.get_animation("Kick").length / 2)
	else:
		if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"):
			character_move(90, SPEED, 0)
		elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"):
			character_move(0, 0, SPEED)
		elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"):
			character_move(180, 0, -SPEED)
		elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
			character_move(270, -SPEED, 0)
		elif Input.is_action_pressed("ui_up"):
			character_move(45, SPEED, SPEED)
		elif Input.is_action_pressed("ui_left"):
			character_move(135, SPEED, -SPEED)
		elif Input.is_action_pressed("ui_right"):
			character_move(315, -SPEED, SPEED)
		elif Input.is_action_pressed("ui_down"):
			character_move(225, -SPEED, -SPEED)
		else:
			if not idling:
				$AnimationPlayer.stop()
			$AnimationPlayer.play("Idle")
			idling = true
	
	# Gravity implementing		
	for i in range(get_slide_count() - 1):
		var collision = get_slide_collision(i)
		if collision.collider.name == "HTerrain":
			GRAVITY = 0
	if get_slide_count() == 0:
		GRAVITY = -10


func _on_Timer_timeout():
	input_listen = true


func _on_body_area_area_entered(area):
	#print(area.get_parent().name)
	if not "attack_area" in area.name:
		return
	var stat_node = area.get_parent().get_node("stats")
	if stat_node.is_pet:
		return
#    $AnimationPlayer.stop()
#    input_listen = false
#    $AnimationPlayer.play("React")
#    $Timer.start($AnimationPlayer.get_animation("React").length - ANIMATION_DELTA)
	# do the damage here
	print("leo dam", stat_node.DAMAGE)
	$Armature/stats.deltaHP(stat_node.DAMAGE)


func _on_stats_HPZERO():
	print("dead")
	get_tree().change_scene("res://2D/YouLose.tscn")



func _on_Fire1_pressed():
	if get_node("Armature").get_node("stats").XP > 10:
		get_node("Armature").get_node("stats").XP -= 10
		spell_list.append("awc")
		spell_inst.append(fire1)
		$"../StatMenu/exp_label".text = "XP PTS: " + str(get_node("Armature").get_node("stats").XP)
		$"../StatMenu/TabContainer/SP Attacks/Fire1_panel/Fire1".text = "AWC"
		$"../StatMenu/TabContainer/SP Attacks/Fire1_panel/Fire1".disabled = true

func _on_Fire2_pressed():
	if get_node("Armature").get_node("stats").XP > 150:
		get_node("Armature").get_node("stats").XP -= 150
		spell_list.append("zxdx")
		spell_inst.append(fire2)
		$"../StatMenu/exp_label".text = "XP PTS: " + str(get_node("Armature").get_node("stats").XP)
		$"../StatMenu/TabContainer/SP Attacks/Fire1_panel/Fire1".text = "ZXDX"
		$"../StatMenu/TabContainer/SP Attacks/Fire1_panel/Fire1".disabled = true


func _on_Fire3_pressed():
	if get_node("Armature").get_node("stats").XP > 270:
		get_node("Armature").get_node("stats").XP -= 270
		spell_list.append("scxqs")
		spell_inst.append(fire3)
		$"../StatMenu/exp_label".text = "XP PTS: " + str(get_node("Armature").get_node("stats").XP)
		$"../StatMenu/TabContainer/SP Attacks/Fire1_panel/Fire1".text = "SCXQS"
		$"../StatMenu/TabContainer/SP Attacks/Fire1_panel/Fire1".disabled = true




func _on_Water1_pressed():
	if get_node("Armature").get_node("stats").XP > 10:
		get_node("Armature").get_node("stats").XP -= 10
		spell_list.append("sez")
		spell_inst.append(water1)
		$"../StatMenu/exp_label".text = "XP PTS: " + str(get_node("Armature").get_node("stats").XP)
		$"../StatMenu/TabContainer/SP Attacks/Fire1_panel/Fire1".text = "SEZ"
		$"../StatMenu/TabContainer/SP Attacks/Fire1_panel/Fire1".disabled = true


func _on_Water2_pressed():
	if get_node("Armature").get_node("stats").XP > 150:
		get_node("Armature").get_node("stats").XP -= 150
		spell_list.append("ezcw")
		spell_inst.append(water2)
		$"../StatMenu/exp_label".text = "XP PTS: " + str(get_node("Armature").get_node("stats").XP)
		$"../StatMenu/TabContainer/SP Attacks/Fire1_panel/Fire1".text = "EZCW"
		$"../StatMenu/TabContainer/SP Attacks/Fire1_panel/Fire1".disabled = true


func _on_Water3_pressed():
	if get_node("Armature").get_node("stats").XP > 270:
		get_node("Armature").get_node("stats").XP -= 270
		spell_list.append("asdqa")
		spell_inst.append(water3)
		$"../StatMenu/exp_label".text = "XP PTS: " + str(get_node("Armature").get_node("stats").XP)
		$"../StatMenu/TabContainer/SP Attacks/Fire1_panel/Fire1".text = "ASDQA"
		$"../StatMenu/TabContainer/SP Attacks/Fire1_panel/Fire1".disabled = true


func _on_Lightning1_pressed():
	if get_node("Armature").get_node("stats").XP > 10:
		get_node("Armature").get_node("stats").XP -= 10
		spell_list.append("dqa")
		spell_inst.append(lightning1)
		$"../StatMenu/exp_label".text = "XP PTS: " + str(get_node("Armature").get_node("stats").XP)
		$"../StatMenu/TabContainer/SP Attacks/Fire1_panel/Fire1".text = "DQA"
		$"../StatMenu/TabContainer/SP Attacks/Fire1_panel/Fire1".disabled = true




func _on_Lightning2_pressed():
	if get_node("Armature").get_node("stats").XP > 150:
		get_node("Armature").get_node("stats").XP -= 150
		spell_list.append("sdcq")
		spell_inst.append(lightning2)
		$"../StatMenu/exp_label".text = "XP PTS: " + str(get_node("Armature").get_node("stats").XP)
		$"../StatMenu/TabContainer/SP Attacks/Fire1_panel/Fire1".text = "SDCQ"
		$"../StatMenu/TabContainer/SP Attacks/Fire1_panel/Fire1".disabled = true




func _on_Lightning3_pressed():
	if get_node("Armature").get_node("stats").XP > 270:
		get_node("Armature").get_node("stats").XP -= 270
		spell_list.append("zeedz")
		spell_inst.append(lightning3)
		$"../StatMenu/exp_label".text = "XP PTS: " + str(get_node("Armature").get_node("stats").XP)
		$"../StatMenu/TabContainer/SP Attacks/Fire1_panel/Fire1".text = "ZEEDZ"
		$"../StatMenu/TabContainer/SP Attacks/Fire1_panel/Fire1".disabled = true
