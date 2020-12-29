extends Spatial


signal new_pet_added(name)


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    get_pet()


func _on_Button_pressed():
    if get_tree().paused:
        print("ok")
        get_tree().paused = false
    else:
        get_tree().paused = true

var temp_monster_name
var temp_xp_needed = 0

func ask_create_pet():
    $PetDialog/pet_ask_label.text = "Do you want " + temp_monster_name + " as your pet? (needs " + str(temp_xp_needed) + ", you have " + str($Leonard/Armature/stats.XP) + ")"
    get_tree().paused = true
    $PetDialog.popup_centered()


func _on_no_button_pressed():
    var node = get_node(temp_monster_name)
    if node != null:
        get_node(temp_monster_name).queue_free()
    get_tree().paused = false
    $PetDialog.hide()


func get_pet():
    if $pets.get_child_count() == 0:
        $GameScreen/petname_label.text = "None"
        $GameScreen/petlv_label.text = ""
        $GameScreen/pet_hp_bar.value = 0
    else:
        var current_pet = $pets.get_child(0)
        var current_pet_stats = current_pet.get_node("stats")
        $GameScreen/petname_label.text = current_pet.name
        $GameScreen/petlv_label.text = "Lv " + str(current_pet_stats.LV)
        $GameScreen/pet_hp_bar.value = current_pet_stats.HP
        $GameScreen/pet_hp_bar.max_value = current_pet_stats.max_HP


func _on_yes_button_pressed():
    
    if temp_xp_needed > $Leonard/Armature/stats.XP:
        print("not enough")
        _on_no_button_pressed()
        return
    
    $Leonard/Armature/stats.XP -= temp_xp_needed
    var monster_node = get_node(temp_monster_name)
    remove_child(monster_node)
    monster_node.get_node("stats").is_pet = true
    monster_node.get_node("stats").stat_reset()
    #monster_node.get_node("damage_area").get_node("CollisionShape").disabled = true
    emit_signal("new_pet_added", temp_monster_name)
    $pets.add_child(monster_node)
    get_tree().paused = false
    $PetDialog.hide()
