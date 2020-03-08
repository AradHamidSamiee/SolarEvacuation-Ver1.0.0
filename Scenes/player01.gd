extends Node2D

var pause_active = false
var dev_console_active = false

var fuelbar = 100.00
var fuelpower = 1.0
var scalebar = 1.00
var wormhole_available = false

var time = OS.get_datetime()
var year = time["year"]

func _ready():
	get_node("pause_menu").visible = false
	get_node("dev_console").visible = false
	ui_display()

func _process(delta):
	pause_manu()
	dev_console()

func ui_display():
#	---- year ----
	get_node("ui_display/year").text = "year: " + str(year)
#	---- fuel ----
	get_node("ui_display/fuel").text = "fuel: " + "100.0"
#	---- size ----
	get_node("ui_display/scale").text = "size: " + "1.0"

func pause_manu():
	if Input.is_action_just_released("pause"):
		if pause_active == false:
			get_node("pause_menu").visible = true
			pause_active = true
		else:
			get_node("pause_menu").visible = false
			pause_active = false

func dev_console():
	if Input.is_action_just_released("dev_console"):
		if dev_console_active == false:
			get_node("dev_console").visible = true
			dev_console_active = true
		else:
			get_node("dev_console").visible = false
			dev_console_active = false

