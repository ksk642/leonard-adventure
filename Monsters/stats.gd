extends Node

export var LV = 1
export var max_HP = 1
onready var HP = max_HP setget deltaHP

export var attack = 3
export var DAMAGE = 1
var xp = 0

export var can_be_pet = false
export var is_pet = false

export var cost = 0

# var leonard_stats = get_parent().get_parent().get_node("Leonard").get_node("Armature").get_node("stats")
var leonard_stats
var exp_pt = max_HP * (0.5)

signal stats_changed(notif)
signal HPZERO(monster)

func _ready():
	# print("a", get_parent().get_parent().get_node("Leonard"))
	leonard_stats = get_parent().get_parent().get_node("Leonard").get_node("Armature").get_node("stats")

func xp_increase(xp_pts):
	xp += xp_pts
	var lv_up_cond = pow(2, LV+1) * 10
	if lv_up_cond <= xp:
		LV += 1
		max_HP = max_HP + 10
		HP = max_HP
		attack = attack + 10

	

func stat_reset():
	HP = max_HP


func deltaHP(value):
	if HP <= 0:
		return
	HP -= value
	print(get_parent().name, " hp left: ", HP)
	# notify
	emit_signal("stats_changed", get_parent().name + " lost " + str(value) + " HP. " + str(HP) + " HP left.")
	if HP <= 0:
		#get_parent().get_node("damage_area").get_node("CollisionShape").disabled = true
		leonard_stats.add_XP(max_HP * 0.5)
		emit_signal("HPZERO", max_HP * 0.5)
		
