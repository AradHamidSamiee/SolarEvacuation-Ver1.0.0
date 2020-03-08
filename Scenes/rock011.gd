extends KinematicBody

func _on_Area_body_entered(body):
	if body.name == "Player":
		print("boom")
