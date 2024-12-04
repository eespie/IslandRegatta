extends Node

func save_permanent_data():
	var save_file = FileAccess.open("user://savepersistant.save", FileAccess.WRITE)
	var node_data = GameManager.save_permanent_data()
	var json_string = JSON.stringify(node_data)
	save_file.store_line(json_string)
	
func load_permanent_data():
	if not FileAccess.file_exists("user://savepersistant.save"):
		return # Error! We don't have a save to load.
		# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://savepersistant.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data = json.data
		GameManager.load_permanent_data(node_data)
	
	EventBus.sigLoadPermanentDataDone.emit()


# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the persist category and ask them to return a
# dict of relevant variables.
func save_game():
	save_permanent_data()
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	var node_data = GameManager.save_game()
	var json_string = JSON.stringify(node_data)
	save_file.store_line(json_string)
	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node has a save function.
		if !node.has_method("save_game"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		node_data = node.call("save_game")

		# JSON provides a static method to serialized JSON string.
		json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)
		
# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	load_permanent_data()
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data = json.data
		
		if node_data["name"] == "GameManager":
			GameManager.load_game(node_data)
		else:
			var loaded_node = get_node_or_null(node_data["name"])
			if loaded_node:
				loaded_node.load_game(node_data)
		
