extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_credit_button_pressed():
    $credit_dialog.popup_centered()
    pass # Replace with function body.


func _on_close_button_pressed():
    pass # Replace with function body.


func _on_quit_button_pressed():
    get_tree().quit()
    pass # Replace with function body.


func _on_control_button_pressed():
    $control_dialog.popup_centered()
    pass # Replace with function body.


func _on_controls_dialog_about_to_show():
    var img = preload("res://icon.png")
#    print(img.get_size())
    #$control_dialog/ItemList.add_item("Normal attack")
    #$control_dialog/ItemList.add_item("Ctrl-A")
#    $control_dialog/ItemList.add_item("HEllo world1", img)
#    $control_dialog/ItemList.add_item("HEllo world2", img)
#    $control_dialog/ItemList.add_item("HEllo world3", img)
#    $control_dialog/ItemList.add_item("HEllo world4", img)
    pass


func _on_start_button_pressed():
    get_tree().change_scene("res://World/World.tscn")
