extends KinematicBody

var planet_speed = 3
#var planet_speed = 30
#var planet_acceleration = 10
var planet_acceleration = 0.3
var planet_velocity = Vector3()
var is_moving_using_keys = false
var shift_mode_active = false

var camera_distance = 0
onready var raycast_defense = get_node("orbiting_rocket_launcher_station/raycast_shoot")
onready var raycast_collision = get_node("raycast_collision")
onready var raycast_collision2 = get_node("raycast_collision2")
onready var planet_camera = get_node("Camera")
var is_shooting = false
var defense_mode_is_active = false
onready var canon_animations = get_node("orbiting_rocket_launcher_station/AnimationPlayer")

var planet_velocity_x_max = 0
var planet_velocity_y_max = 0

var scale_addition = Vector3(0.1,0.1,0.1)
var camera_zoom_min = 3
var camera_zoom_max = 40
var target_dir = Vector2(0,0)

func _ready():
	camera_zoom_out()
	get_node("orbiting_rocket_launcher_station").visible = false

func _process(delta):
	planet_controller(delta)
	camera_control()
	defense_control()
	collision_detection()
	# a func for anim later
	if is_shooting == false:
		canon_animations.play("canon_rotation", 1, -0.5)
	# a func for updating size later
	get_node("../..").current_size = get_node("kine_collisionshape").shape.radius
	# astro func later
	get_node("../..").astrolocation.x = translation.x
	get_node("../..").astrolocation.y = translation.y

#--------------------------------------- Camera Zoom -----------------------------------------
func camera_zoom_out():
	while camera_distance <= 7:
		yield(get_tree().create_timer(0.03),"timeout")
		get_node("Camera").translation.z += 0.1
		camera_distance += 0.1
	get_node("Camera").translation.z = 11
	camera_distance = 0

#--------------------------------------- Planet Controller -----------------------------------
func planet_controller(delta):
#	var target_dir = Vector2(0,0)
	if Input.is_action_pressed("up_thrust"):
		target_dir.y += 0.11
		is_moving_using_keys = true
	elif Input.is_action_pressed("right_thrust"):
		target_dir.x += 0.11
		is_moving_using_keys = true
	elif Input.is_action_pressed("down_thrust"):
		target_dir.y -= 0.11
		is_moving_using_keys = true
	elif Input.is_action_pressed("left_thrust"):
		target_dir.x -= 0.11
		is_moving_using_keys = true
	else:
		is_moving_using_keys = false
#	print(target_dir)
	if target_dir.x <= 0.1 and target_dir.x >= -0.1:
		target_dir.x = 0
	if target_dir.y <= 0.1 and target_dir.y >= -0.1:
		target_dir.y = 0
	if target_dir.x > 1:
		target_dir.x = 1
	if target_dir.x < -1:
		target_dir.x = -1
	if target_dir.y > 1:
		target_dir.y = 1
	if target_dir.y < -1:
		target_dir.y = -1
	
#	target_dir = target_dir.normalized()
	planet_velocity.x = lerp (planet_velocity.x, target_dir.x * planet_speed, planet_acceleration * delta)
	planet_velocity.y = lerp (planet_velocity.y, target_dir.y * planet_speed, planet_acceleration * delta)
	
	if get_node("../..").fuelbar != 0:
		planet_velocity = move_and_slide(planet_velocity, Vector3(0,0,planet_velocity.z))
	
	if Input.is_action_pressed("getaway_thrust"):
		planet_speed = 10
		planet_acceleration = 2
	else:
		planet_speed = 3
		planet_acceleration = 0.3
	
	# fuel ui part
	if (target_dir.x != 0 or target_dir.y != 0) and is_moving_using_keys == true:
		get_node("../..").fuelbar -= get_node("../..").fuelconsume_meter * sqrt((planet_velocity.x * planet_velocity.x) + (planet_velocity.y * planet_velocity.y))
	elif target_dir.x == 0 or target_dir.y == 0:
		get_node("../..").fuelbar = get_node("../..").fuelbar
	
	if get_node("../..").fuelbar <= 0:
		get_node("../..").fuelbar = 0
		print("lost in space, frozen in mere fear")
	
	# vel ui part
	get_node("../..").vel = sqrt((planet_velocity.x * planet_velocity.x) + (planet_velocity.y * planet_velocity.y)) * 3

#--------------------------------------- CAMERA CONTROL --------------------------------------
func camera_control():
	
	if get_node("Camera").translation.z < camera_zoom_min:
		get_node("Camera").translation.z = camera_zoom_min
	if get_node("Camera").translation.z > camera_zoom_max:
		get_node("Camera").translation.z = camera_zoom_max
	
	if Input.is_action_just_released("scroll_up"):
		if get_node("Camera").translation.z <= camera_zoom_max and get_node("Camera").translation.z > camera_zoom_min:
			get_node("Camera").translation.z -= 0.5
	elif Input.is_action_just_released("scroll_down"):
		if get_node("Camera").translation.z >= camera_zoom_min and get_node("Camera").translation.z <= camera_zoom_max:
			get_node("Camera").translation.z += 0.5
	
	if Input.is_action_pressed("scroll_up_joystick"):
		if get_node("Camera").translation.z <= camera_zoom_max and get_node("Camera").translation.z > camera_zoom_min:
			get_node("Camera").translation.z -= 0.5
	elif Input.is_action_pressed("scroll_down_joystick"):
		if get_node("Camera").translation.z >= camera_zoom_min and get_node("Camera").translation.z <= camera_zoom_max:
			get_node("Camera").translation.z += 0.5

#--------------------------------------- DEFESNSE --------------------------------------------
func defense_control():
	if Input.is_action_just_released("defense_mode") and defense_mode_is_active == false:
		get_node("orbiting_rocket_launcher_station").visible = true
		defense_mode_is_active = true
		yield(get_tree().create_timer(0.05),"timeout")
	elif Input.is_action_just_released("defense_mode") and defense_mode_is_active == true:
		get_node("orbiting_rocket_launcher_station").visible = false
		defense_mode_is_active = false
		yield(get_tree().create_timer(0.05),"timeout")
	
	if Input.is_action_just_released("shoot") and is_shooting == false and defense_mode_is_active == true:
		is_shooting = true
		# if u r using laser
		canon_animations.play("shoot")
		get_node("orbiting_rocket_launcher_station/laser").emitting = true
		# if u r using blackhole drier
#		get_node("orbiting_rocket_launcher_station/BHD").emitting = true
		# if u r using star eater
#		get_node("orbiting_rocket_launcher_station/SEA").emitting = true
		camera_shake()
		if raycast_defense.is_colliding():
			var collider_object = raycast_defense.get_collider()
			if collider_object.is_in_group("celestial_body"):
				yield(get_tree().create_timer(0.1),"timeout")
				collider_object.queue_free()
		yield(get_tree().create_timer(0.1),"timeout")
		is_shooting = false

#--------------------------------------- COLLISION CHECK -------------------------------------
func collision_detection():
	
	#scanning the environement by rotating fast
	raycast_collision.rotate_z(deg2rad(30))
	raycast_collision2.rotate_z(deg2rad(30))
	
	#checking for any celestial objects 1
	if raycast_collision.is_colliding():
		var collider = raycast_collision.get_collider()
		if collider.is_in_group("celestial_body"):
			if collider.size <= get_node("kine_collisionshape").shape.radius:
				camera_shake()
				print("kaboom")
				collider.queue_free()
				get_node("kine_collisionshape").shape.radius += 0.1
				get_node("MeshInstance").scale += scale_addition
				get_node("raycast_collision").cast_to.x += 0.1
				get_node("raycast_collision2").cast_to.x += 0.1
				camera_zoom_max += 1
				camera_zoom_min += 1
				get_node("../..").uc += collider.size
				get_node("orbiting_rocket_launcher_station").translation.x += 0.1
		if collider.is_in_group("blackhole"):
			print("u just got blackholed")
			get_tree().change_scene("res://Scenes/main_menu.tscn")
		if collider.is_in_group("star"):
			print("burn mf burn mf buuurrrrn")
			get_tree().change_scene("res://Scenes/main_menu.tscn")
	
	if raycast_collision2.is_colliding(): #checking for any celestial objects 2
		var collider2 = raycast_collision2.get_collider()
		if collider2.is_in_group("celestial_body"):
			if collider2.size <= get_node("kine_collisionshape").shape.radius:
				camera_shake()
				print("kaboom")
				collider2.queue_free()
				get_node("kine_collisionshape").shape.radius += 0.1
				get_node("MeshInstance").scale += scale_addition
				get_node("raycast_collision").cast_to.x += 0.1
				get_node("raycast_collision2").cast_to.x += 0.1
				camera_zoom_max += 1
				camera_zoom_min += 1
				get_node("../..").uc += 1
		if collider2.is_in_group("blackhole"):
			print("u just got blackholed")
			get_tree().change_scene("res://Scenes/main_menu.tscn")
		if collider2.is_in_group("star"):
			print("burn mf burn mf buuurrrrn")
			get_tree().change_scene("res://Scenes/main_menu.tscn")

#--------------------------------------- CAMERA SHAKE ----------------------------------------
func camera_shake():
	planet_camera.rotation.z = -0.02
	yield(get_tree().create_timer(0.04),"timeout")
	planet_camera.rotation.z = 0.02
	yield(get_tree().create_timer(0.04),"timeout")
	planet_camera.rotation.z = 0
