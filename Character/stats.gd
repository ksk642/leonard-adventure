extends Node


signal healthPointChanged(new_hp, new_max_hp)
signal magicPointChanged(new_mp, new_max_mp)
signal stats_changed(notif)
signal levelChange(new_lv)
signal HPZERO

var RNG = RandomNumberGenerator.new()

# player stat
export var LV = 1
onready var max_HP = 100 + RNG.randi_range(-10,10)
onready var HP = max_HP setget deltaHP
onready var max_MP = 1800#100 + RNG.randi_range(-10,10)
onready var MP = max_MP

export var attack = 17
var DAMAGE = attack
export var SPatt = 3
export var crit = 5
export var defense = 5
export var HPrecovery = 0
export var MPrecovery = 1

var total_exp = 0
export var XP = 100


func cost():
	return 1

func add_XP(xp_pts):
	total_exp += xp_pts
	XP += xp_pts
	var lv_up_cond = pow(2, LV+1) * 10
	if lv_up_cond <= total_exp:
		LV += 1
		max_HP = max_HP + 20 + RNG.randi_range(3,10)
		HP = max_HP
		max_MP = max_MP + 30 + RNG.randi_range(0,5)
		MP = max_MP
		emit_signal("levelChanged", LV)
	
func _ready():
	RNG.randomize()
	attack = 10 + RNG.randi_range(3,6) * 2
	SPatt = 10 + RNG.randi_range(3,6) * 2
	crit = 	10 + RNG.randi_range(3,6) * 2
	defense = 10 + RNG.randi_range(3,6) * 2
	HPrecovery = 10 + RNG.randi_range(3,6) * 2
	MPrecovery = 10 + RNG.randi_range(3,6) * 2
	print("stats:", [max_HP, HP, max_MP, MP, attack, SPatt, crit, defense, HPrecovery, MPrecovery])
	
	emit_signal("healthPointChanged", HP, max_HP)
	emit_signal("magicPointChanged", MP, max_MP)
	emit_signal("levelChange", LV)


func deltaHP(value):
	HP -= value * 0.125 * (1 - (defense/400))
	print("dam rec", HP)
	emit_signal("healthPointChanged", HP, max_HP)
	emit_signal("stats_changed", "Leonard lost " + str(value) + " HP")
	if HP <= 0:
		print("dead")
		emit_signal("HPZERO")


func deltaMP(value):
	MP -= value
	print("mp changed", MP)
	emit_signal("magicPointChanged", MP, max_MP)
	emit_signal("stats_changed", "Leonard lost " + str(value) + " MP")
	if MP < 0:
		MP = 0

func deltaLV(value):    
	LV += value    
	print("LV changed", LV)    
	emit_signal("levelChanged", LV)    
	emit_signal("stats_changed", "Leonard becomes level " + str(LV))


func _on_recovery_timer_timeout():
	# recovery
	var trueHPrecovery = HPrecovery * 0.04
	var tmp = min(max_HP - HP, trueHPrecovery)
	if tmp > 0:
		HP += tmp
		emit_signal("stats_changed", "Leonard recovered " + str(tmp) + " HP")
	
	var trueMPrecovery = MPrecovery * 0.1
	tmp = min(max_MP - MP, trueMPrecovery)
	if tmp > 0:
		MP += tmp
		emit_signal("stats_changed", "Leonard recovered " + str(tmp) + " MP")
	emit_signal("healthPointChanged", HP, max_HP)
	emit_signal("magicPointChanged", MP, max_MP)
	
