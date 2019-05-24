extends Control

func _ready():
	$MenuButtonFile.get_popup().add_item("Open File")
	$MenuButtonFile.get_popup().add_item("Save as File")
	$MenuButtonFile.get_popup().add_item("Quit")
	
	$MenuButtonFile.get_popup().connect("id_pressed", self, "_on_item_pressed", ["MenuButtonFile"])
	
	$MenuButtonHelp.get_popup().add_item("About")
	$MenuButtonHelp.get_popup().connect("id_pressed", self, "_on_item_pressed", ["MenuButtonHelp"])
	
func _on_item_pressed(id, menuName):
	# can be another way of doing this. Beside getting id.
	# this is our implementation, for now.
	var menu = $MenuButtonFile if menuName == 'MenuButtonFile' else $MenuButtonHelp
	var item_name = menu.get_popup().get_item_text(id)
	match item_name:
		"Open File":
			_on_openFile_pressed()
		"Save as File":
			_on_saveFile_pressed()
		"Quit":
			_quit_app()
		'About':
			$aboutDialog.popup()

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