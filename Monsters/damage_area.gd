extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var RNG = RandomNumberGenerator.new()

func _on_damage_area_area_entered(area):
	if area.name != "my_damage_area":
		return
	print("x", area.get_parent().name)
	var stat_node = area.get_parent().get_node("stats")
	
#    print($"..".name, "ok")
#    return
#    if stat_node == null:
#        stat_node = $"../../..".get_node("stats")
	var tmp = get_tree().get_root().get_node("World/Leonard")
	if tmp.is_a_parent_of(area):
		if tmp.get_node("Armature").is_a_parent_of(area):
			RNG.randomize()
			var critical = RNG.randi_range(1,100)
			print(critical)
			if critical < (stat_node.crit/4):
				$"../stats".deltaHP(stat_node.attack*1.5)
				print("Dam ", stat_node.attack)
			else:
				$"../stats".deltaHP(stat_node.attack)
	if "Spell" in area.get_parent().get_parent().name:
		stat_node = area.get_parent().get_parent().get_node("stats")
		print("b", stat_node.DAMAGE)
		var sp_mod = 0.1
		sp_mod = (tmp.get_node("Armature").get_node("stats").SPatt / 400) + 1
		print(sp_mod)
		$"../stats".deltaHP(stat_node.DAMAGE)
	else:
		#print(area.get_parent().name)
		print("z", area.get_parent().name)
		print("Dam1 ", stat_node.DAMAGE)
		$"../stats".deltaHP(stat_node.DAMAGE)
