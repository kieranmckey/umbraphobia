extends CanvasLayer



func _on_player_health_updated(health):
	$Health.text = str(health) + "%"
