extends Control

var appName = "Text Editor Tutorial"
var currentFile = "Untitled"
var menuDict = {
	'MenuButtonFile' : ["New File", "Open File", "Save", "Save as File", "Quit"],
	'MenuButtonHelp' : ["Godot Website", "About"]
}

func _ready():
	_set_menuScreen_objects()

	_updateWindowTitle()

	_set_menuScreen_shortcut_keys()

func _set_menuScreen_shortcut_keys():
	$MenuButtonFile.get_popup().set_item_shortcut(4, _set_shortcut(KEY_Q), true) # 3rd parameter tells that this shortcut is global

func _set_menuScreen_objects():
	# menuItem is a string
	# menuDict[menuItem] is an array
	for menuItem in menuDict:
		_add_menu_items(menuItem, menuDict[menuItem])
		_invoke_signals(menuItem)

# create signals
func _invoke_signals(menuName):
	_set_menu_root(menuName).get_popup().connect("id_pressed", self, "_on_item_pressed", [menuName])

func _add_menu_items(menuName, menuItems):
	for item in menuItems:
		_set_menu_root(menuName).get_popup().add_item(item)

func _set_menu_root(menuName):
	var menu = $MenuButtonFile if menuName == 'MenuButtonFile' else $MenuButtonHelp
	return menu

func _set_shortcut(key):
	# alternative way of setting a shortcut key
	# Besides using the project settings' input map
	var shortcut = ShortCut.new()
	var inputEventKey = InputEventKey.new()
	inputEventKey.set_scancode(key) #if keyboard key 'Q' is pressed
	inputEventKey.control = true #if keyboard key 'Control' is pressed
	shortcut.set_shortcut(inputEventKey) #re-sets and confirms the variables/properties of the instance set above.
	return shortcut
	
func _updateWindowTitle():
	OS.set_window_title(appName + ' - ' + currentFile)
	
func _newFile():
	currentFile = "Untitled"
	_updateWindowTitle()
	$TextEdit.text = ''

# can be another way of doing this. Besides getting id.
# this is our implementation, for now.
func _on_item_pressed(id, menuName):
	var item_name = _set_menu_root(menuName).get_popup().get_item_text(id)
	match item_name:
		"Open File":
			_on_openFile_pressed()
		"New File":
			_newFile()
		"Save":
			_saveFile()
		"Save as File":
			_on_saveFile_pressed()
		"Quit":
			_quit_app()
		'About':
			$aboutDialog.popup()
		'Godot Website':
			return OS.shell_open("https://godotengine.org")

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
	var f = File.new()
	f.open(path, 1)
	$TextEdit.text = f.get_as_text()
	f.close()
	currentFile = path
	_updateWindowTitle()

func _on_saveFileDialogue_file_selected(path):
	var f = File.new()
	f.open(path, 2)
	f.store_string($TextEdit.text)
	f.close()
	currentFile = path
	_updateWindowTitle()

func _quit_app():
	get_tree().quit()
	
func _saveFile():
	var path = currentFile
	if path == 'Untitled':
		$saveFileDialogue.popup()
	else:
		var f = File.new()
		f.open(path, 2)
		f.store_string($TextEdit.text)
		f.close()
		_updateWindowTitle()