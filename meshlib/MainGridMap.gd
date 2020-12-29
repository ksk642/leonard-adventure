extends GridMap

var orientation
var x
var z
var rotList = [0,10,16,22]

export var maxNum = 0
export var minNum = 0

#preload each file as as a constant
#eg const Bear = preload("filepath")
#create meshlib for each monster
#use get_used_cells_by_id() in ready
#var bear = get used cells by id(0)

const Cobra = preload("res://Monsters/Normal/Cobra/Cobra.tscn")
const Locust = preload("res://Monsters/Normal/Locust/Locust.tscn")
const Rhino = preload("res://Monsters/Normal/Rhino/Rhino.tscn")
const Rocknose = preload("res://Monsters/Normal/Rocknose/Rocknose.tscn")


func get_used_cells_by_id(id: int):
	var arr = []
	var cells = get_used_cells()
	for i in cells:
		print(i)
		if(get_cell_item(i.x, i.y, i.z) == id):
			arr.append(i)
	return cells

func replaceMeshwithInst(cells: Array, inst):
	var cellPos = Vector3()
	for i in cells:
		var newObject = newObject(i, cellPos, inst)

func newObject(cell: Vector3, cellPos: Vector3, inst):
	var newInst = inst.instance()
	cellPos = map_to_world(cell.x, cell.y, cell.z)
	newInst.translation = cellPos
	set_cell_item(cell.x, cell.y, cell.z, -1)
	add_child(newInst)

var RNG = RandomNumberGenerator.new()

func randomTiling(max_num, min_num, x_range: Array, z_range: Array):
	var max_x = x_range[1]
	var min_x = x_range[0]
	var max_z = z_range[1]
	var min_z = z_range[0]
	RNG.randomize()
	var num = RNG.randi_range(min_num, max_num)
	for i in range(num):
		orientation = rotList[RNG.randi_range(0,3)]
		var mesh_num = RNG.randi_range(0,3)
		x = RNG.randi_range(min_x, max_x)
		z = RNG.randi_range(min_z, max_z)
		#print(x,z," ",orientation)
		set_cell_item(x, 0, z, mesh_num, orientation)
	

func _ready():
	#var cobra = get_used_cells_by_id(0)
	#var locust = get_used_cells_by_id(1)
	#var rhino = get_used_cells_by_id(2)
	#var rocknose = get_used_cells_by_id(3)
	#randomTiling(10, 15, [20,30], [20,90])
	#replaceMeshwithInst(cobra, Cobra)
	#print(get_used_cells())
	"""
	RNG.randomize()
	var num = RNG.randi_range(5,10)
	for i in range(num):
		orientation = rotList[RNG.randi_range(0,3)]
		print(orientation)
		x = RNG.randi_range(-10,9)
		z = RNG.randi_range(-10,9)
		#print(x,z," ",orientation)
		set_cell_item(x, 0, z, 0, orientation)
	"""
	
	
	
