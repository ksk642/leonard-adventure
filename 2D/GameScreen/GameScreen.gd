extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_stats_healthPointChanged(new_hp, new_max_hp):
	$hp_bar.value = new_hp
	$hp_bar.max_value = new_max_hp


func _on_stats_magicPointChanged(new_mp, new_max_mp):
	$mp_bar.value = new_mp
	$mp_bar.max_value = new_max_mp

func _on_stats_levelChanged(new_lv):    
	$lv_label.text = "Lv " + str(new_lv)


func _on_pause_button_pressed():
	get_tree().paused = true
	var stat_menu = $"../StatMenu"
	var leonard_stat = $"../Leonard/Armature/stats"
	# level
	stat_menu.get_node("lv_label").text = "Lv " + str(leonard_stat.LV)
	# hp
	stat_menu.get_node("HP_bar").max_value = leonard_stat.max_HP
	stat_menu.get_node("HP_bar").value = leonard_stat.HP
	# mp
	stat_menu.get_node("MP_bar").max_value = leonard_stat.max_MP
	stat_menu.get_node("MP_bar").value = leonard_stat.MP
	# att
	stat_menu.get_node("TabContainer/Stats/HBoxContainer/att_label").text = str(leonard_stat.attack)
	# def
	stat_menu.get_node("TabContainer/Stats/HBoxContainer2/def_label").text = str(leonard_stat.defense)
	# crit
	stat_menu.get_node("TabContainer/Stats/HBoxContainer3/crit_label").text = str(leonard_stat.crit)
	# sp att
	stat_menu.get_node("TabContainer/Stats/HBoxContainer4/spatt_label").text = str(leonard_stat.SPatt)
	# hp heal
	stat_menu.get_node("TabContainer/Stats/HBoxContainer5/hpheal_label").text = str(leonard_stat.HPrecovery)
	# mp heal
	stat_menu.get_node("TabContainer/Stats/HBoxContainer6/mpheal_label").text = str(leonard_stat.MPrecovery)
	# exp
	stat_menu.get_node("exp_label").text = "EXP PTS: " + str(leonard_stat.XP)

	stat_menu.visible = true


func _on_stats_stats_changed(notif):
	if not $status_label.text.empty():
		notif = "\n" + notif
	$status_label.text += notif
	pass # Replace with function body.


func _on_stats_levelChange(new_lv):
	$lv_label.text = "Lv " + str(new_lv)
