extends RigidBody

var planet_speed = 5
var planet_acceleration = 15
var planet_velocity = Vector3()

var camera_distance = 0
onready var planet_raycast = get_node("orbiting_rocket_launcher_station/RayCast")
var is_shooting = false

func _ready():
	camera_zoom_out()
	get_node("orbiting_rocket_launcher_station/laser").visible = false

func _process(delta):
	planet_controller(delta)
	camera_control()
	camera_shake()
	raycast_collision_detection()
	defense_control()

#--------------------------------------- Camera Zoom -----------------------------------------
func camera_zoom_out():
	while camera_distance <= 7:
		yield(get_tree().create_timer(0.04),"timeout")
		get_node("Camera").translation.z += 0.1
		camera_distance += 0.1
	get_node("Camera").translation.z = 10
	camera_distance = 0

#--------------------------------------- Planet Controller -----------------------------------
func planet_controller(delta):
	var target_dir = Vector2(0,0)
	if Input.is_action_pressed("up_thrust"):
		target_dir.y += 1
	if Input.is_action_pressed("right_thrust"):
		target_dir.x += 1
	if Input.is_action_pressed("down_thrust"):
		target_dir.y -= 1
	if Input.is_action_pressed("left_thrust"):
		target_dir.x -= 1
	
	target_dir = target_dir.normalized()
	planet_velocity.x = lerp (planet_velocity.x, target_dir.x * planet_speed, planet_acceleration * delta)
	planet_velocity.z = lerp (planet_velocity.z, target_dir.y * planet_speed, planet_acceleration * delta)
	
	planet_velocity = move_and_slide(planet_velocity, Vector3(0,0,planet_velocity.z))

#--------------------------------------- CAMERA CONTROL --------------------------------------
func camera_control():
	
	if get_node("Camera").translation.z < 2:
		get_node("Camera").translation.z = 3
	if get_node("Camera").translation.z >= 30:
		get_node("Camera").translation.z = 30
	
	if Input.is_action_just_released("scroll_up"):
		if get_node("Camera").translation.z <= 30 and get_node("Camera").translation.z > 2:
			get_node("Camera").translation.z -= 0.5
	elif Input.is_action_just_released("scroll_down"):
		if get_node("Camera").translation.z >= 2 and get_node("Camera").translation.z <= 30:
			get_node("Camera").translation.z += 0.5

#--------------------------------------- DEFESNSE --------------------------------------------
func defense_control():
	if Input.is_action_just_released("shoot") and is_shooting == false:
		get_node("orbiting_rocket_launcher_station/laser").visible = true
		is_shooting = true
		yield(get_tree().create_timer(0.1),"timeout")
		get_node("orbiting_rocket_launcher_station/laser").visible = false
		is_shooting = false

#--------------------------------------- COLLISION CHECK -------------------------------------
func raycast_collision_detection():
	pass

#--------------------------------------- CAMERA SHAKE ----------------------------------------
func camera_shake():
	pass
