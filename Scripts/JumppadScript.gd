extends Node3D

class_name JumpPad

#value variables
@export_group("value variables")
@export var jumpBoostValue : float

@onready var jumpPad = $jumppad_model/pad
@onready var jumpPadBean = $jumppad_model/JumpPadBeam
@onready var animation = $AnimationPlayer

func _ready():
	jumpPad.monitoring = false

func enablePad():
	jumpPad.monitoring = true
	jumpPadBean.visible = true
	animation.play('powerup')
	animation.play('activated')

func _on_area_3d_2_area_entered(area):
	if area.get_parent() is PlayerCharacter: area.get_parent().jump(jumpBoostValue, true) # Replace with function body.
