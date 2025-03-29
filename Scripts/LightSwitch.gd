extends Node3D

var health:int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func damage(amount, _dir):
	Audio.play("sounds/enemy_hurt.ogg")

	health -= amount

	if health <= 0:
		if get_tree():	
			await get_tree().create_timer(0.1).timeout
			queue_free()
