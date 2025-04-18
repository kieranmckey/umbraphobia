extends Node3D

#@onready var hit_rect = $CanvasLayer/HitRect #TODO
@onready var spawns = $Map/Spawns
@onready var interruptSpawns = $Map/InterruptSpawns
@onready var navigation_region = $Map/NavigationRegion3D
@onready var interruptorsState = $WorldHUD/HBoxContainer/VBoxContainer2/iStat
@onready var startMenu = $StartMenu
@onready var missionBriefPlayer = $AnimationPlayer
@onready var missionBrief = $MissionBrief
#@onready var audioPlayer = $Audio/AudioStreamPlayer
@onready var jumpPad = $Map/NavigationRegion3D/JumpPad
@onready var animation = $AnimationPlayer


@export var interruptorNumber = 10

var currentInterruptorNumber

var alien = load("res://Scenes/Alien.tscn")
var interruptor = load("res://Scenes/Light_switch.tscn")
var instance


# Called when the node enters the scene tree for the first time.
func _ready():	
	#audioPlayer.playing = true
	startMenu.setPauseMenu(true, true)
	randomize()
	var spawnPositions = []	
	while spawnPositions.size() < interruptorNumber:
		var spawnPoint = _get_random_child(interruptSpawns).global_position
		if spawnPoint not in spawnPositions:
			spawnPositions.append(spawnPoint)
			instance = interruptor.instantiate()
			instance.position = spawnPoint
			instance.scale = Vector3(2.0, 2.0, 2.0)
			navigation_region.add_child(instance)	
	
	interruptorsState.set_text(str(interruptorNumber))
	currentInterruptorNumber = interruptorNumber
	missionBriefPlayer.play('ShowBrief')	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)

func _on_zombie_spawn_timer_timeout():
	var spawn_point = _get_random_child(spawns).global_position
	instance = alien.instantiate()
	instance.position = spawn_point
	navigation_region.add_child(instance)
	
func _on_interruptor_dead():
	currentInterruptorNumber = currentInterruptorNumber - 1
	interruptorsState.set_text(str(currentInterruptorNumber))
	if currentInterruptorNumber == 0:
		#animation.stop()
		animation.play('ShowMessage')
		jumpPad.enablePad()
	if !animation.is_playing():
		animation.play('InterruptorDead')
	

func _on_area_3d_area_entered(_area):
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name):
	if anim_name=='ShowBrief':
		missionBrief.visible = false
