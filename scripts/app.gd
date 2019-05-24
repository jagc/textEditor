extends Control

func _ready():
	$MenuButtonFile.get_popup().add_item("Open File")
	$MenuButtonFile.get_popup().add_item("Save as File")
	$MenuButtonFile.get_popup().add_item("Quit")
	
	$MenuButtonFile.get_popup().connect("id_pressed", self, "_on_item_pressed")
	
func _on_item_pressed(arg):
	match arg:
		0:
			_on_openFile_pressed()
		1:
			_on_saveFile_pressed()
		2:
			_quit_app()

func _process(_delta):
	if Input.is_action_just_pressed("saveFile"):
		_on_saveFile_pressed()
	elif Input.is_action_just_pressed("openFile"):
		_on_openFile_pressed()
	elif Input.is_action_just_pressed("quit"):
		_quit_app()
		
func _on_openFile_pressed():
	$FileDialog.popup()

func _on_saveFile_pressed():
	$saveFileDialogue.popup()


func _on_FileDialog_file_selected(path):
	print(path)
	var f = File.new()
	f.open(path, 1)
	$TextEdit.text = f.get_as_text()
	f.close()

func _on_saveFileDialogue_file_selected(path):
	var f = File.new()
	f.open(path, 2)
	f.store_string($TextEdit.text)
	f.close()

func _quit_app():
	get_tree().quit()