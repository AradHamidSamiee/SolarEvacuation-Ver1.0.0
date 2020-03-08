extends Control

func _on_btn_exit_pressed():
	get_tree().quit()

func _on_btn_start_pressed():
	get_tree().change_scene("res://Scenes/World01.tscn")
	pass # Replace with function body.

func _on_btn_upgrade_pressed():
	get_node("upgrade_panel").visible = true

func _on_btn_options_pressed():
	pass # Replace with function body.

func _on_btn_customize_pressed():
	pass # Replace with function body.

func _ready():
	get_node("background/AnimationPlayer").play("main_menu_rotation")

func _on_btn_credits_pressed():
	pass # Replace with function body.

func _on_btn_log_pressed():
	pass # Replace with function body.

func _on_back_pressed():
	get_node("upgrade_panel").visible = false
