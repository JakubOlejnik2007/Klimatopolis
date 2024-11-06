extends Node3D

var MapGenerator3D = preload("res://MapGenerator.gd")
var GroundModel = preload("res://models/ground.fbx")
var House1 = preload("res://models/house1.fbx")
var House2 = preload("res://models/house2.fbx")
var WaterModel = preload("res://models/wasser.fbx")

func _ready() -> void:
	var map_generator = MapGenerator3D.new()
	var map_size = Vector2(60, 60)
	var map = map_generator.generate_map(map_size)

	var x = map_size.x*-1
	for row in map:
		var y = map_size.y*-1-2
		for cell in row:
			y += 2
			var instance = GroundModel.instantiate()
			if cell == MapGenerator3D.TerrainType.VOID:
				continue
			match cell:
				MapGenerator3D.TerrainType.GRASS:
					instance = GroundModel.instantiate()
				MapGenerator3D.TerrainType.WATER:
					instance = WaterModel.instantiate()
				

			instance.position = Vector3(x, 0, y)

			add_child(instance)
			
		x += 2
