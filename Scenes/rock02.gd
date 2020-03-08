extends KinematicBody

onready var size = get_node("CollisionShape").shape.radius

func _ready():
	pass

func _process(delta):
	translation.y -= 0.1
