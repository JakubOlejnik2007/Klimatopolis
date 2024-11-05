enum TerrainType { GRASS, VOID, WATER }

func generate_map(size: Vector2) -> Array:
	var map = []
	var noise = FastNoiseLite.new()
	
	noise.seed = randi()  # Ustawienie losowego nasienia dla różnorodności mapy
	var scale = 0.1  # Skala szumu dla lepszego detalu
	var island_shape_noise = FastNoiseLite.new()
	island_shape_noise.seed = randi()  # Ustawiamy inne nasienie dla kształtu wyspy
	island_shape_noise.set_noise_type(FastNoiseLite.NoiseType.TYPE_SIMPLEX)
	
	# Ustal ilość max komórek WATER
	var max_water_cells = int(size.x * size.y * 0.3)  # Woda <= 40% mapy
	var water_cells_count = 0  # Licznik komórek wody

	for x in range(size.x):
		var row = []
		for y in range(size.y):
			# Uzyskanie wartości hałasu dla kształtu wyspy
			var island_value = island_shape_noise.get_noise_2d(x * 0.15, y * 0.15)

			# Wyznaczenie terenu na podstawie wartości hałasu
			if island_value > 0.2:  # Obszar wyspy
				row.append(TerrainType.GRASS)
			else:
				# Przydzielanie wody, jeśli nie przekroczy to 40%
				if water_cells_count < max_water_cells:
					row.append(TerrainType.WATER)
					water_cells_count += 1
				else:
					row.append(TerrainType.GRASS)  # Po osiągnięciu limitu wody dodajemy GRASS

		map.append(row)

	# Wprowadzenie losowych wycięć w obszarze wyspy
	for i in range(20):  # Zwiększenie liczby wycięć
		var cut_x = int(randi()) % int(size.x)
		var cut_y = int(randi()) % int(size.y)
		var cut_radius = randi() % 4 + 2  # Zmniejszenie promienia wycięcia dla większej precyzji
		
		for dx in range(-cut_radius, cut_radius + 1):
			for dy in range(-cut_radius, cut_radius + 1):
				if cut_x + dx >= 0 and cut_x + dx < size.x and cut_y + dy >= 0 and cut_y + dy < size.y:
					if dx * dx + dy * dy <= cut_radius * cut_radius:  # Ograniczenie do kształtu okręgu
						if map[cut_x + dx][cut_y + dy] == TerrainType.GRASS:
							map[cut_x + dx][cut_y + dy] = TerrainType.WATER  # Zmiana na WATER
							water_cells_count += 1  # Zwiększanie licznika wody

	# Wprowadzenie dodatkowych wycięć w krawędziach
	for x in range(size.x):
		for y in range(size.y):
			if (x < 2 or x >= size.x - 2 or y < 2 or y >= size.y - 2) and map[x][y] == TerrainType.GRASS:
				if randf() < 0.3:  # Losowa szansa na wycięcie w krawędziach
					map[x][y] = TerrainType.WATER  # Zmiana na WATER
					water_cells_count += 1  # Zwiększanie licznika wody

	return map
