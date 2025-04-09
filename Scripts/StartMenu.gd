extends CanvasLayer

var pauseMenuEnabled : bool = false
var mouseFree : bool = false 

@export var optionsMenu : CanvasLayer 

func _ready():
	pass#setPauseMenu(false, false)
	
func _process(_delta):
	pass
			
func setPauseMenu(value : bool, enable : bool):
	#set the pause penu behaviour (visibility, mouse control, ...)
	visible = value
	mouseFree = value
	pauseMenuEnabled = enable
	
	#stop game process when the pause menu is enabled
	if pauseMenuEnabled: Engine.time_scale = 0.0
	else: Engine.time_scale = 1.0
	
	if mouseFree: 
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else: 
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _on_resume_button_pressed():
	#close pause menu
	
	#there is a bug here, i don't know why, but the mouse keep being free when the pause menu is closed via the resume button
	#you can set the mouse to not free again by closing the menu directly with the key input
	#if you know how to resolve that issue, don't hesitate to make a post about it on the discussions tab of the project's Github repository
	
	setPauseMenu(false, false)
	
func _on_options_button_pressed():
	#close pause menu, but keep it enabled, to block possible reopen while being on the options menu
	if optionsMenu != null:
		setPauseMenu(false, true)
		optionsMenu.setOptionsMenu(true) #open options menu
	
func _on_quit_button_pressed():
	#close the window, and so close the game
	get_tree().quit()
	
