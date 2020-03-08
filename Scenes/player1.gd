extends Spatial

var pause_active = false
var dev_console_active = false

var fuelbar = 100.00
var fuelconsume_meter = 0.015
var fuelpower = 1.0 #??
var current_size = 1.00
var sizeunit = "earth"
var wormhole_available = false
var uc = 0.00
var vel = 0.00

var time = OS.get_datetime()
var year = 2020
var earth_still_intact = 100
var astrolocation = Vector2(0,0)
onready var animations = get_node("Model/AnimationPlayer")

var time_start = 0
var time_now = 0

#--------------------------------------- READY -----------------------------------------------
func _ready():
	get_node("pause_menu").visible = false
	get_node("dev_console").visible = false
	year = time["year"]
	time_start = OS.get_unix_time()

#--------------------------------------- DELTA -----------------------------------------------
func _process(delta):
	pause_manu()
	dev_console()
	sizeunites_dic()
	time_pass()
	ui_update()
	earth_animation()
	reset_scene()
	freeze_z_axis()

#--------------------------------------- FREEZE Z AXIS ---------------------------------------
func freeze_z_axis():
	get_node("Model/KinematicBody").translation.z = 0
#	print("planet axis: ", get_node("Model/KinematicBody").translation)
	
#--------------------------------------- RESET SCENE -----------------------------------------
func reset_scene():
	if Input.is_action_just_released("reset_scene"):
		get_node("Model/KinematicBody/kine_collisionshape").shape.radius = 1
		get_tree().reload_current_scene()

#---------------------------------- EARTH ANIMATIONS -----------------------------------------
func earth_animation():
		animations.play("earth_rotation")

#--------------------------------------- UI UPDATE -------------------------------------------
func ui_update():
#	---- year ----
	get_node("ui_display/year").text = "year: " + str(year) + " virtual AD"
#	---- fuel ----
	get_node("ui_display/fuel").text = "fuel: " + str(stepify(fuelbar, 0.01)) +" su"
#	---- size ----
	get_node("ui_display/scale").text = "size: " + str(stepify(current_size, 0.01)) +"x " + sizeunit + "(s)"
#	---- intact --
	get_node("ui_display/still_intact").text = "intactess: " + str(earth_still_intact) + "%"
#	---- uc ------
	get_node("ui_display/union_credits").text = "uc: " + str(uc) + " $$$"
#	-- defense ---
	var defense_mode = get_node("Model/KinematicBody").defense_mode_is_active
	if defense_mode == true:
		get_node("ui_display/defense_mode").text = "defense mode: Activated"
	elif defense_mode == false:
		get_node("ui_display/defense_mode").text = "defense mode: Deactivated"
#	---- astro ---
	get_node("ui_display/astrolocation").text = "coord: " + str(stepify(astrolocation.x/25, 0.01)) + "," + str(stepify(astrolocation.y/25, 0.01)) + " au"
#	---- vel -----
	get_node("ui_display/vel").text = "vel: " + str(stepify(vel, 0.01)) + " Gm/sec"
#--------------------------------------- TIME PASS -------------------------------------------
func time_pass():
	if pause_active == false: #bug report - in pause, seconds and elapsed time is still being calculated
		time_now = OS.get_unix_time()
		var elapsed = time_now - time_start
#		print("et", elapsed)
		var seconds = elapsed % 60
#		print("sc", seconds)
		if seconds >= 59:
			seconds = 0
			year += 1
			earth_still_intact -= 20
			time_start = OS.get_unix_time()
		if fuelbar == 0 and seconds >= 1:
			earth_still_intact -= 1
			seconds = 0
		if earth_still_intact <= 0:
			get_tree().change_scene("res://Scenes/main_menu.tscn")

#--------------------------------------- SIZE UNIT DICTIONARY --------------------------------
func sizeunites_dic():
	if current_size <= 10:
		sizeunit = "earth"
	elif current_size > 10:
		sizeunit = "jupiter"

#--------------------------------------- PAUSE MENU ------------------------------------------
func pause_manu():
	if Input.is_action_just_released("pause"):
		get_tree().change_scene("res://Scenes/main_menu.tscn")
#		get_node("dev_console").visible = false
#		if pause_active == false:
#			get_node("pause_menu").visible = true
#			pause_active = true
#		else:
#			get_node("pause_menu").visible = false
#			pause_active = false

#--------------------------------------- DEV CONSOLE -----------------------------------------
func dev_console():
	if Input.is_action_just_released("dev_console") and pause_active == false:
		if dev_console_active == false:
			get_node("dev_console").visible = true
			dev_console_active = true
		else:
			get_node("dev_console").visible = false
			dev_console_active = false
			get_node("dev_console/TextEdit").undo()

func _on_TextEdit_text_changed():
	if get_node("dev_console/TextEdit").text == "year up":
		year += 1
	else:
		print("non")
