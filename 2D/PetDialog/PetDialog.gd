extends WindowDialog

var temp_monster_name

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_SPACE:
			get_tree().set_input_as_handled()
	#get_tree().paused = false
	# get_parent()._on_no_button_pressed()


func _on_PetDialog_popup_hide():
	$".."._on_no_button_pressed()
	get_tree().paused = false
