extends KinematicBody

var planet_speed = 16
var planet_acceleration = 15
var planet_velocity = Vector3()

func _process(delta):
	planet_controller(delta)

#--------------------------------------- Planet Controller -----------------------------------
func planet_controller(delta):
	var target_dir = Vector2(0,0)
	if Input.is_action_pressed("up_thrust"):
		target_dir.y += 1
		print(target_dir)
	if Input.is_action_pressed("right_thrust"):
		target_dir.x += 1
		print(target_dir)
	if Input.is_action_pressed("down_thrust"):
		target_dir.y -= 1
		print(target_dir)
	if Input.is_action_pressed("left_thrust"):
		target_dir.x -= 1
		print(target_dir)
	
	target_dir = target_dir.normalized()
	planet_velocity.x = lerp (planet_velocity.x, target_dir.x * planet_speed, planet_acceleration * delta)
	planet_velocity.y = lerp (planet_velocity.y, target_dir.y * planet_speed, planet_acceleration * delta)
	print("x", planet_velocity.x)
	print("y", planet_velocity.y)
	print("z", planet_velocity.z)
	
	planet_velocity = move_and_slide(planet_velocity, Vector3(0,1,0))
	print("p", planet_velocity)
