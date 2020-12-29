extends GridMap


onready var MAIN_GRID_MAP = get_node("../MainGridMap")
onready var READY = false

func addMesh(cells: Array, new_mesh):
	for i in cells:
		#print(i.x, i.y, i.z)
		set_cell_item(i.x, i.y, i.z, new_mesh)

func _ready():
	print("b")
	var treePos = MAIN_GRID_MAP.get_used_cells_by_id(0)
		#print(treePos)
	addMesh(treePos, 1)


 

