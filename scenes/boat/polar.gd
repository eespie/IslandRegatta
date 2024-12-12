extends Node

var polar_file : String = "res://assets/polar/60ftmono.json"
var polar_data : Dictionary
var min_tws : int = 4
var max_tws : int = 37

func _ready():
	var content : FileAccess = FileAccess.open(polar_file, FileAccess.READ)
	var json_string : String = content.get_line()
	var json : JSON = JSON.new()

	# Check if there is any error while parsing the JSON string, skip in case of failure.
	var parse_result : Error = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return

	# Get the data from the JSON object.
	polar_data = json.data
	
func get_speed(twa : int, tws : int) -> float:
	tws = clampi(tws, min_tws, max_tws)
	return polar_data[twa][tws]
