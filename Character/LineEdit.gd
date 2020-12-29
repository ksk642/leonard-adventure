extends LineEdit

onready var player = $".."
var activate = ""
signal MAGIC

func _ready():
	connect("text_entered", self, "on_text_entered");
	grab_focus();


func _on_LineEdit_text_changed(new_text):
	$Timer2.start(1.5)
	if new_text in player.spell_list:
		activate = new_text

		emit_signal("MAGIC")
		clear()
	else:
		if len(new_text) >= 5:
			clear()
	

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode in [KEY_Q, KEY_W, KEY_E, KEY_A, KEY_S, KEY_D, KEY_Z, KEY_X, KEY_C]:
			return
		else:
			get_tree().set_input_as_handled()


func _on_Timer2_timeout():
	clear()


func _on_back_button_pressed():
	connect("text_entered", self, "on_text_entered");
	grab_focus();
