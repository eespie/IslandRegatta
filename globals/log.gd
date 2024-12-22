extends Node

enum LOG_LEVEL {trace, debug, info, error}

var log_level : LOG_LEVEL = LOG_LEVEL.debug

func display(level : LOG_LEVEL, msg : String) -> void:
	if level >= log_level:
		print(msg)

func trace(msg : String) -> void:
	display(LOG_LEVEL.trace, msg)
	
func debug(msg : String) -> void:
	display(LOG_LEVEL.debug, msg)
	
func info(msg : String) -> void:
	display(LOG_LEVEL.info, msg)
	
func error(msg : String) -> void:
	display(LOG_LEVEL.error, msg)
