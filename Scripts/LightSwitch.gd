extends Node3D

var health:int = 10

signal interruptorDead 

@onready var animationPlayer = $AnimationPlayer
@onready var light = $OmniLight3D
@onready var lightGlobe = $OmniLight3D/Globe
@onready var explosion = $CPUParticles3D
@onready var machine = $machine_wireless
@onready var collider = $CollisionShape3D

var world = null
@export var worldPath := "/root/World"


# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_node(worldPath) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func damage(amount, _dir):
	
	if health == 0:
		animationPlayer.play("Die")
		emit_signal("interruptorDead")
		explosion.emitting = true
		machine.visible = false
		collider.disabled = true
		light.visible = true
		world._on_interruptor_dead()
	if health > 0:
		animationPlayer.play("Hit")
		health -= amount
		#light.omni_range = light.omni_range + 2
		#light.light_energy = light.omni_range + 2
		#var glow:float = 0.0		
		#glow = lightGlobe.get_surface_override_material(0).get_shader_parameter("Glow_Power")
		#glow = glow + 2.0
		#lightGlobe.get_surface_override_material(0).set_shader_parameter("Glow_Power", glow)

	
	
		
	#	if get_tree():	
	#		await get_tree().create_timer(0.1).timeout
	#		queue_free()
