extends Node


export var lv = 1
export var attack = 2
var DAMAGE = attack
export var MPcost = 0
export (String, "fire", "water", "lightning") var type
export var command = "aaa"
export var use_count = 0
export var locked = true

signal UNLOCKED

func unlock():
	locked = false
	emit_signal("UNLOCKED")

