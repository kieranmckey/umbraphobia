extends Node3D

class_name JumpPad

#value variables
@export_group("value variables")
@export var jumpBoostValue : float

@onready var jumppad = $jumppad_model/pad

func ready():
	jumppad.monitoring = false

func enablePad():
	jumppad.monitoring = true

func _on_area_3d_2_area_entered(area):
	if area.get_parent() is PlayerCharacter: area.get_parent().jump(jumpBoostValue, true) # Replace with function body.
