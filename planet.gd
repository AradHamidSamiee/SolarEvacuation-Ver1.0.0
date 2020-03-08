extends KinematicBody

onready var size = get_node("CollisionShape").shape.radius
onready var p_height = get_node("MeshInstance").mesh.height
onready var p_radius = get_node("MeshInstance").mesh.radius

func _process(delta):
	get_node("MeshInstance").mesh.height = p_height
	get_node("MeshInstance").mesh.radius = p_radius
