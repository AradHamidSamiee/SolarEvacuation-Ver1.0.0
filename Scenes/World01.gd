extends Spatial

onready var looneytoons = get_node("moon_axis/moon/AnimationPlayer")
onready var sunneytoons = get_node("Sun/AnimationPlayer")

# load to spawn
onready var celestial_body_container = get_node("Player/celestial_body_container")
var celestial_body_planet = preload("res://Scenes/planet01.tscn")
var celestial_body_star = preload("res://Scenes/Sun01.tscn")
var celestial_body_rock = preload("res://Scenes/rock01.tscn")
var celestial_body_blackhole = preload("res://Scenes/blackhole01.tscn")
var next_chunck_coord = Vector3(0, 0, 0)
var mat_star = load("res://Scenes/mat_sun.tres")
var mat_rock = load("res://Scenes/mat_rockplanet.tres")
var mat_jupiter = load("res://Scenes/mat_jupiter.tres")
var mat_mercury = load("res://Scenes/mat_mercury.tres")
var mat_ice = load("res://Scenes/mat_iceplanet.tres")
var mat_black = load("res://Scenes/mat_blackhole01.tres")

#--------------------------------------- READY -----------------------------------------------
func _ready():
	looneytoons.play("orbiting_moon", 1, 0.1)
	sunneytoons.play("sun_spin", 1, 0.01)

#--------------------------------------- DELTA -----------------------------------------------
func _process(delta):
#	get_node("Player/ui_display/union_credits").text = str(stepify(get_node("Player/Model/KinematicBody").translation.x, 0.1)) + ":" + str(stepify(get_node("Player/Model/KinematicBody").translation.y, 0.1))
	pass

func _on_spawn_celestial_body_timeout():
	# instance
	var planet_instance = celestial_body_planet.instance()
	var rock_instance = celestial_body_rock.instance()
	var star_instance = celestial_body_star.instance()
	var blackhole_instance = celestial_body_blackhole.instance()
	# geolocation
	var num_x = rand_range(-1.0, 1.0)
	var num_y = rand_range(-1.0, 1.0)
	planet_instance.transform.origin = Vector3(next_chunck_coord.x + num_x, next_chunck_coord.y + num_y, 0) * 10
	# spawn
	var random_material = round(rand_range(0, 100))
	var random_size
	if random_material > 95:
		planet_instance.get_node("MeshInstance").material_override = mat_black
		random_size = round(rand_range(10, 30))
		planet_instance.p_radius = random_size
		planet_instance.p_height = random_size * 2
		print("black - ", planet_instance.p_radius, " - ", random_size, " - ", planet_instance.translation)
		
	if random_material <= 95 and random_material > 80:
		planet_instance.get_node("MeshInstance").material_override = mat_ice
		random_size = round(rand_range(30, 60))
		planet_instance.p_radius = random_size
		planet_instance.p_height = random_size * 2
		planet_instance.rotation.y = 180
		print("ice - ", planet_instance.p_radius, " - ", random_size, " - ", planet_instance.translation, " - ", planet_instance.rotation.y)
		
	if random_material <= 80 and random_material > 60:
		planet_instance.get_node("MeshInstance").material_override = mat_star
		random_size = round(rand_range(20, 50))
		planet_instance.p_radius = random_size
		planet_instance.p_height = random_size * 2
		print("star - ", planet_instance.p_radius, " - ", random_size, " - ", planet_instance.translation)
		
	if random_material <= 60 and random_material > 30:
		planet_instance.get_node("MeshInstance").material_override = mat_rock
		random_size = round(rand_range(1, 10))
		planet_instance.p_radius = random_size
		planet_instance.p_height = random_size * 2
		print("rock - ", planet_instance.p_radius, " - ", random_size, " - ", planet_instance.translation)
		
	if random_material <= 30 and random_material > 15:
		planet_instance.get_node("MeshInstance").material_override = mat_jupiter
		random_size = round(rand_range(5, 15))
		planet_instance.p_radius = random_size
		planet_instance.p_height = random_size * 2
		print("juice - ", planet_instance.p_radius, " - ", random_size, " - ", planet_instance.translation)
		
	if random_material <= 15 and random_material >= 1:
		planet_instance.get_node("MeshInstance").material_override = mat_mercury
		print("merc - ", planet_instance.p_radius, " - ", random_size, " - ", planet_instance.translation)
	celestial_body_container.add_child(planet_instance)
