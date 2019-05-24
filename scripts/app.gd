extends Control

func _ready():
	pass # Replace with function body.

func _process(_delta):
	if Input.is_action_just_pressed("saveFile"):
		_on_saveFile_pressed()
	elif Input.is_action_just_pressed("openFile"):
		_on_openFile_pressed()
	elif Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
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
