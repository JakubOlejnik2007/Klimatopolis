extends Node3D

class_name MapGenerator3D

enum TerrainType { GRASS, VOID, WATER }

var map_size = Vector2(40, 40)
var map = []

func _ready():
	map = generate_map(map_size)
	print_map()

func generate_map(size: Vector2) -> Array:
	var generated_map = []
	for y in range(size.y):
		var row = []
		for x in range(size.x):
			row.append(TerrainType.VOID)
		generated_map.append(row)
	
	generate_island(generated_map)
	generate_water(generated_map)
	return generated_map

func generate_island(map: Array):
	var island_center = Vector2(map_size.x / 2, map_size.y / 2)
	var max_radius = min(map_size.x, map_size.y) / 3  # Maksymalny promień wyspy

	for y in range(map_size.y):
		for x in range(map_size.x):
			var distance = (island_center - Vector2(x, y)).length()
			if distance < max_radius:
				map[y][x] = TerrainType.GRASS  # Zwiększamy obszar GRASS

				# Wprowadzenie dodatkowej losowości dla naturalnego kształtu
				if randf() < (max_radius - distance) / max_radius * 0.5:  # Zmniejszamy losowość, by bardziej ujednolicić ląd
					map[y][x] = TerrainType.GRASS

func generate_water(map: Array):
	var water_path_start = Vector2(randf() * map_size.x, 0)
	var water_path_end = Vector2(randf() * map_size.x, map_size.y)
	var river_width = int(randf() * 3 + 2)  # Szerokość rzeki

	for i in range(int(map_size.y / 3), int(map_size.y * 2 / 3)):
		var x_pos = int(water_path_start.x + (water_path_end.x - water_path_start.x) * (i / map_size.y) + randf_range(-2, 2))
		if x_pos >= 0 and x_pos < map_size.x:
			for width in range(-river_width, river_width + 1):
				var x = x_pos + width
				if x >= 0 and x < map_size.x:
					map[i][x] = TerrainType.WATER

	# Zapewnij, że otoczenie rzeki również jest terenem GRASS, jeśli to możliwe
	for y in range(int(map_size.y / 3), int(map_size.y * 2 / 3)):
		for x in range(map_size.x):
			if map[y][x] == TerrainType.WATER:
				for dx in range(-1, 2):
					var nx = x + dx
					if nx >= 0 and nx < map_size.x and map[y + 1][nx] == TerrainType.VOID:
						map[y + 1][nx] = TerrainType.GRASS  # Przekształcamy VOID w GRASS wokół rzeki

func print_map():
	for row in map:
		var row_string = ""
		for cell in row:
			match cell:
				TerrainType.GRASS: row_string += "G "
				TerrainType.WATER: row_string += "W "
				TerrainType.VOID: row_string += ". "
		print(row_string)
