extends CharacterBody3D

var player = null
var state_machine
var health = 2

const SPEED = 4.0
const ATTACK_RANGE = 14.0

@export var player_path := "/root/World/Map/NavigationRegion3D/PlayerCharacter/Player"

# Bullets
var bullet = load("res://Scenes/Bullet.tscn")
var instance

var destroyed := false

@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree
@onready var raycast = $RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector3.ZERO
	
	match state_machine.get_current_node():
		"Walk":
			# Navigation
			nav_agent.set_target_position(player.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * 10.0)
		"Shoot":
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)			
			#raycast.force_raycast_update()
			#if raycast.is_colliding():
			#	var collider = raycast.get_collider()
				#if collider.has_method("hit"):  # Raycast collides with player	
			#	if collider.is_in_group("player"):
			#		_hit_finished()		
					#Audio.play("sounds/enemy_attack.ogg")
					#collider.hit((raycast.global_basis * raycast.target_position).normalized())

		"Die":
			anim_tree.set("parameters/conditions/dienow", true)
			await get_tree().create_timer(4.0).timeout
			queue_free()
	
	# Conditions
	anim_tree.set("parameters/conditions/shoot", _target_in_range())
	anim_tree.set("parameters/conditions/walk", !_target_in_range())
	
	move_and_slide()


func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE


func _hit_finished():
	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 1.0:
		var dir = global_position.direction_to(player.global_position)
		player.hit(dir)

func _fire():
	instance = bullet.instantiate()
	instance.position = raycast.global_position # todo add correct gun pos
	instance.transform.basis = raycast.global_transform.basis
	get_parent().add_child(instance)

func _on_area_3d_body_part_hit(dam): #TODO remove
	health -= dam
	if health <= 0:
		state_machine = anim_tree["parameters/playback"]
		state_machine.travel("Die")
		
func damage(amount, dir):
	Audio.play("Sounds/enemy_hurt.ogg")

	health -= amount

	if health <= 0 and !destroyed:
		destroyed = true
		state_machine = anim_tree["parameters/playback"]
		state_machine.travel("Die")		
		
