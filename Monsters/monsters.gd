extends KinematicBody


export var ACCELERATION = 3
export var SPEED = 4
export var FRICTION = 5

const GRAVITY = -1
const PET_DIST = 10.0
const EPS_DIST = 1.0
const PLAYER_NAME = "Leonard"

enum {
	IDLE,
	CHASE,
	ATTACK
}

var state = IDLE
var velocity = Vector3.ZERO
const EPS = 0.01

onready var vision = $vision_area
onready var hitRange = $attack_area
onready var stats = $stats

var attack_mode = false # inside
var counter = 0
var attack = false
var exp_damage


var current_angle = 0


func my_look_at(me, target):
	var deltax = target.x - me.x
	var deltaz = target.z - me.z
	var angle = atan2(deltax, deltaz)
	if abs(angle - current_angle) > 0.3:
		rotate_y(angle - current_angle)
		current_angle = angle
		
func disable_attack():
	$attack_area/CollisionShape.disabled = true


func _ready():
	var ttimer = Timer.new()
	ttimer.name = "attack_timer"
	add_child(ttimer)
	ttimer.set_one_shot(true)
	ttimer.connect("timeout", self, "disable_attack")
	


func _physics_process(delta):
	# gravity
	move_and_slide(Vector3(0, GRAVITY, 0))

	if stats.is_pet:
		match state:
			IDLE:
				var player = get_parent().get_parent().get_node("Leonard")
				var target = player.global_transform.origin
				my_look_at(global_transform.origin, target)
				var dist = target - global_transform.origin
				var direction = dist.normalized()
				velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
				if dist.length() > PET_DIST or not player.idling:
#                    print("walking..", dist.length(), " ", player.idling)
					$scene/AnimationPlayer.play("Walk")
					move_and_slide(velocity)
				else:
					$scene/AnimationPlayer.play("Idle")
				seek_player()
				
			CHASE:
				var player = vision.get_player()
				if player != null:
					player = vision.get_player().front()
					var target = player.global_transform.origin
					my_look_at(global_transform.origin, target)
					var direction = (target - global_transform.origin).normalized()
					velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
					$scene/AnimationPlayer.play("Walk")
					$attack_area/CollisionShape.disabled = false
					attack_player()
				else:
					state = IDLE

			ATTACK:
				var player = hitRange.get_player()
				if player != null:
					$scene/AnimationPlayer.play("Attack")
				else:
					state = CHASE
	else:
#        print("ok!?")
		match state:
			IDLE: 
				$scene/AnimationPlayer.play("Idle")
				velocity = velocity.move_toward(Vector3.ZERO, FRICTION * delta)
				seek_player()
			
			CHASE: 
				var player = vision.get_player()
				if player != null:
					for body in player:
						if body.name == "Leonard":
							player = body
				if typeof(player) == TYPE_ARRAY:
					player = null
				#print("chase", player.name)
				if player != null:
						my_look_at(global_transform.origin, player.global_transform.origin)
						var target = player.global_transform.origin
						var direction = (target - global_transform.origin).normalized()
						velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
						$scene/AnimationPlayer.play("Walk")
						$attack_area/CollisionShape.disabled = false
						attack_player()
				else:
					state = IDLE
			
			ATTACK:
				var player = hitRange.get_player()
				if player != null:
					#if $attack_area/collision_shape.disabled:
					#	$attack_area/collision_shape.disabled = false
					$scene/AnimationPlayer.play("Attack")
					if $attack_timer.is_stopped():
						$attack_timer.start($scene/AnimationPlayer.current_animation_length)
				else:
					state = CHASE
					$attack_area/CollisionShape.disabled = false

		if velocity.length() > EPS_DIST:
			move_and_slide(velocity)


func make_pet():
	if stats.can_be_pet:
		stats.is_pet = true
		state = IDLE

		
func seek_player():
	if vision.can_see_player():
		state = CHASE


func attack_player():
	if hitRange.can_hit_player():
		
		state = ATTACK


#func _on_damage_area_area_entered(area):
#    if stats.is_pet:
#        if area.get_parent().name == PLAYER_NAME:
#            return
#        print("being pet")
#        if area.name in ["attack_area", "damage_area", "vision_area"]:
#            return
#        print("pet attacked")
#        var stats_node = area.get_parent().get_node("stats")
##        if stats_node != null:
#        stats.deltaHP(stats_node.DAMAGE)
#    else:
#        if area.name in ["attack_area", "damage_area", "vision_area"]:
#            return
##        attack_mode = true
#        var stats_node = area.get_parent().get_node("stats")
#        print("enemy attacked")
#        print(area.get_parent().name)
#        if stats_node != null:
#            stats.deltaHP(stats_node.attack)
##            stats.deltaHP(stats_node.DAMAGE)
##            exp_damage = stats_node.attack


func _on_stats_HPZERO(xp_pts):
	if $stats.can_be_pet:
		if $stats.is_pet:
			$"../../StatMenu/TabContainer/Pets/ItemList".remove_item(0)
			# monster died
			for pet in $"../pets".get_children():
				pet.xp_increase(xp_pts)
				#pet.xp += xp_pts
				pass
			queue_free()
		else:
			print("clgt")
			$"..".temp_monster_name = name
			$"..".temp_xp_needed = stats.cost
			$"..".ask_create_pet()
	else:
		# monster died
		for pet in $"../pets".get_children():
			pet.xp_increase(xp_pts)
			#pet.xp += xp_pts
		queue_free()
