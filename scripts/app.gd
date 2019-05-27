extends Control

const  UNTITLED = "Untitled"

var appName = "Text Editor Tutorial"
var currentFile = UNTITLED
var isModalOpen = false
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
	currentFile = UNTITLED
	_updateWindowTitle()
	$TextEdit.text = ''

# can be another way of doing this. Besides getting id.
# this is our implementation, for now.
func _on_item_pressed(id, menuName):
	var item_name = _set_menu_root(menuName).get_popup().get_item_text(id)
	match item_name:
		"Open File":
			_on_openFile_pressed()
			print(isModalOpen)
		"New File":
			_newFile()
		"Save":
			_saveFile()
			print(isModalOpen)
		"Save as File":
			_on_saveFile_pressed()
			print(isModalOpen)
		"Quit":
			_quit_app()
		'About':
			$aboutDialog.popup()
			isModalOpen = true
			print(isModalOpen)
		'Godot Website':
			return OS.shell_open("https://godotengine.org")

func _process(_delta):
	if Input.is_action_just_pressed("saveFile"):
		_on_saveFile_pressed()
	elif Input.is_action_just_pressed("openFile"):
		_on_openFile_pressed()
	elif Input.is_action_just_pressed("quit"):
		call_deferred("_quit_app")
		
func _on_openFile_pressed():
	$FileDialog.popup()
	isModalOpen = true
#	print(isModalOpen)

func _on_saveFile_pressed():
	$saveFileDialogue.popup()
	isModalOpen = true

func _on_FileDialog_file_selected(path):
	_handleFile(path, 1)
	currentFile = path
	_updateWindowTitle()

func _on_saveFileDialogue_file_selected(path):
	_handleFile(path, 2)
	currentFile = path
	_updateWindowTitle()

func _saveFile():
	var path = currentFile
	if path == UNTITLED:
		$saveFileDialogue.popup()
		isModalOpen = true
	else:
		_handleFile(path, 2)

func _handleFile(path, mode):
	var f = File.new()
	f.open(path, mode)
	if mode == 1:
		$TextEdit.text = f.get_as_text()
	elif mode == 2:
		f.store_string($TextEdit.text)
	f.close()

func _quit_app():
	if isModalOpen == false:
		get_tree().quit()
		print('modal is not open')
#	elif isModalOpen == true:
#		print(isModalOpen)

func _on_FileDialog_popup_hide():
	isModalOpen = false

func _on_saveFileDialogue_popup_hide():
	isModalOpen = false

func _on_aboutDialog_popup_hide():
	isModalOpen = false