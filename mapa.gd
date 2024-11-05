#extends Node3D
#
## Załaduj model 3D (przykład z plikiem res://models/MyModel.glb)
#var MyModel = preload("res://models/road1.fbx")
#
#func _ready():
		## Załaduj scenę .fbx
	#var scene = load("res://models/house1.fbx") # Zmień na odpowiednią ścieżkę
#
	## Utwórz instancję sceny
	#var instance = scene.instantiate()
#
	## Ustaw pozycję instancji
	#instance.position = Vector3(6, 6, 6) # Ustaw odpowiednią lokalizację
#
	## Dodaj instancję do sceny
	#add_child(instance)
#




extends Node3D

var MapGenerator3D = preload("res://MapGenerator.gd")
var GroundModel = preload("res://models/ground.fbx")
var House1 = preload("res://models/house1.fbx")
var House2 = preload("res://models/house2.fbx")

func _ready() -> void:
	var map_generator = MapGenerator3D.new()
	var map_size = Vector2(40, 40)
	var map = map_generator.generate_map(map_size)
	map_generator.print_map()

	if not GroundModel:
		print("GroundModel not loaded")

	var x = map_size.x*-1
	for row in map:
		var y = map_size.y*-1
		for cell in row:
			
			var instance = GroundModel.instantiate()
			print(cell)
			if cell == MapGenerator3D.TerrainType.VOID:
				continue
			match cell:
				MapGenerator3D.TerrainType.GRASS:
					instance = GroundModel.instantiate()
				MapGenerator3D.TerrainType.WATER:
					instance = House1.instantiate()
				

			instance.position = Vector3(x, 0, y)

			add_child(instance)
			y += 2
		x += 2
