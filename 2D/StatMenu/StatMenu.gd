extends Control


#signal att_changed(new_att)
#signal def_changed(new_def)
#signal crit_changed(new_crit)
#signal HPheal_changed(new_HPheal)
#signal MPheal_changed(new_MPheal)

onready var leonard_stats = $"../Leonard/Armature/stats"
#onready var sp_tree = $"TabContainer/SP Attacks/sp_tree"
var sp_att_arr = []


# Called when the node enters the scene tree for the first time.
func _ready():
#    var sp_tree_root = sp_tree.create_item()
#    sp_tree.set_hide_root(true)
#    var fire1_node = sp_tree.create_item(sp_tree_root)
#    fire1_node.set_text(0, "Fire 1")
#    var fire2_node = sp_tree.create_item(fire1_node)
#    fire2_node.set_text(0, "Fire 2")
#    var water1_node = sp_tree.create_item(sp_tree_root)
#    water1_node.set_text(0, "Water 1")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_back_button_pressed():
	visible = false
	get_tree().paused = false


func _on_att_button_pressed():
	var current_exp = int($exp_label.text)
	if current_exp < leonard_stats.cost():
		print("not enough xp")
		return
	leonard_stats.attack += 1
	$"TabContainer/Stats/HBoxContainer/att_label".text = str(leonard_stats.attack)
	# minus exp
	leonard_stats.XP -= leonard_stats.cost()
	$exp_label.text = "XP PTS: " + str(leonard_stats.XP)
#    var new_att = int($"TabContainer/Stats/HBoxContainer/att_label".text) + 1
#    emit_signal("att_changed", new_att)


func _on_def_button_pressed():
	var current_exp = int($exp_label.text)
	if current_exp < leonard_stats.cost():
		print("not enough xp")
		return
	leonard_stats.defense += 1
	$"TabContainer/Stats/HBoxContainer2/def_label".text = str(leonard_stats.defense)
	# minus exp
	leonard_stats.XP -= leonard_stats.cost()
	$exp_label.text = "XP PTS: " + str(leonard_stats.XP)


func _on_crit_button_pressed():
	var current_exp = int($exp_label.text)
	if current_exp < leonard_stats.cost():
		print("not enough xp")
		return
	leonard_stats.crit += 1
	$"TabContainer/Stats/HBoxContainer3/crit_label".text = str(leonard_stats.crit)
	# minus exp
	leonard_stats.XP -= leonard_stats.cost()
	$exp_label.text = "XP PTS: " + str(leonard_stats.XP)


func _on_spatt_button_pressed():
	var current_exp = int($exp_label.text)
	if current_exp < leonard_stats.cost():
		print("not enough xp")
		return
	leonard_stats.SPatt += 1
	$"TabContainer/Stats/HBoxContainer4/spatt_label".text = str(leonard_stats.SPatt)
	# minus exp
	leonard_stats.XP -= leonard_stats.cost()
	$exp_label.text = "XP PTS: " + str(leonard_stats.XP)


func _on_hpheal_button_pressed():
	var current_exp = int($exp_label.text)
	if current_exp < leonard_stats.cost():
		print("not enough xp")
		return
	leonard_stats.HPrecovery += 1
	$"TabContainer/Stats/HBoxContainer5/hpheal_label".text = str(leonard_stats.HPrecovery)
	# minus exp
	leonard_stats.XP -= leonard_stats.cost()
	$exp_label.text = "XP PTS: " + str(leonard_stats.XP)


func _on_mpheal_button_pressed():
	var current_exp = int($exp_label.text)
	if current_exp < leonard_stats.cost():
		print("not enough xp")
		return
	leonard_stats.HPrecovery += 1
	$"TabContainer/Stats/HBoxContainer6/mpheal_label".text = str(leonard_stats.MPrecovery)
	# minus exp
	leonard_stats.XP -= leonard_stats.cost()
	$exp_label.text = "XP PTS: " + str(leonard_stats.XP)


func _on_World_new_pet_added(name):
	$TabContainer/Pets/ItemList.add_item(name, load("res://icon.png"))
	pass # Replace with function body.


func _on_ItemList_item_selected(index):
	var pet_name = $TabContainer/Pets/ItemList.get_item_text(index)
	var pet_node_stats = $"../pets".get_node(pet_name).get_node("stats")
	$TabContainer/Pets/Panel/pet_level.text = "Level\n" + str(pet_node_stats.LV)
	$TabContainer/Pets/Panel/pet_name.text = pet_name
	$TabContainer/Pets/Panel/pet_maxhp.text = "Max HP\n" + str(pet_node_stats.max_HP)
	$TabContainer/Pets/Panel/pet_dam.text = "Damage\n" + str(pet_node_stats.DAMAGE)
	$TabContainer/Pets/Panel/pet_ava.texture = $TabContainer/Pets/ItemList.get_item_icon(index)
