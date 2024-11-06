extends SubViewport

func _ready():
	var screen_size = DisplayServer.window_get_size()
	print(screen_size)


	self.size = screen_size
