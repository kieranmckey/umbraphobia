extends Node3D


const SPEED = 40.0

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
#@onready var particles = $GPUParticles3D
@onready var particles = $VfxOne
@onready var explosion = $VfxOne/GPUParticles3D
@onready var impact = $AudioStreamPlayer3D


var player = null

@export var player_path := "/root/World/Map/NavigationRegion3D/PlayerCharacter/PlayerCharacter"



# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)
	particles.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	#move_and_collide(Vector3(0,0,SPEED * delta))
	if ray.is_colliding():
		impact.play()
		mesh.visible = false		
		ray.enabled = false
		particles.visible = true
		explosion.emitting = true
		if ray.get_collider().has_method("damage"):			
			var dir = global_position.direction_to(player.global_position)	
			ray.get_collider().damage(1, dir)		
		if get_tree():	
			await get_tree().create_timer(0.1).timeout
		queue_free()


func _on_timer_timeout():
	queue_free()
