extends StaticBody3D

@onready var animation = $AnimationPlayer

func _on_area_3d_area_entered(_area):
	animation.play('Finale')
	if get_tree():	
		await get_tree().create_timer(5.0).timeout
	get_tree().reload_current_scene()
