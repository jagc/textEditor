extends Control

var following = false
var draggingStartPosition = Vector2()

func _on_MenuTitleBar_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1:
			following = !following
			draggingStartPosition = get_local_mouse_position()
			
func _process(delta):
	if following:
		OS.set_window_position(OS.window_position + get_global_mouse_position() - draggingStartPosition)

func _on_closeButton_pressed():
	get_tree().quit()

func _on_minimizeButton_pressed():
	OS.set_window_minimized(true)
