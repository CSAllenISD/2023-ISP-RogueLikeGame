extends Node2D

onready var dirt_tilemap = $DirtTileMap
onready var wall_tilemap = $WallTileMap

var rng = RandomNumberGenerator.new()

var CellSize = Vector2(32, 32)
var width = 2048/CellSize.x
var height = 1216/CellSize.y
var grid = []
var walkers = []

class Walker:
	var dir: Vector2
	var pos: Vector2

var max_iterations = 10000

var walker_max_count = 3
var walker_spawn_chance = 0.25
var walker_direction_chance = 0.5
var fill_percent = 0.3
var walker_destroy_chance = 0.2

var neighbors4 = [ [1, 0], [-1, 0], [0, 1], [0, -1]]
var neighbors8 = [ [1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, -1], [1, -1], [-1, 1]]

var Tiles = {
	"empty": -1,
	"wall": 0,
	"floor": 1,
	"dirt": 2
}

func _init_walkers():
	walkers = []

	var walker = Walker.new()
	walker.dir = GetRandomDirection()
	walker.pos = Vector2(width/2, height/2)
	walkers.append(walker)

func _init_grid():
	grid = []
	for x in width:
		grid.append([])
		for y in height:
			grid[x].append(-1);
	

func GetRandomDirection():
	var directions = [[-1, 0], [1, 0], [0, 1], [0, -1]]
	var direction = directions[rng.randi()%4]
	return Vector2(direction[0], direction[1])
	
func _create_random_path():

	var itr = 0
	var n_tiles = 0
	
	while itr < max_iterations:
		
		# Change direction, with chance
		for i in range(walkers.size()):
			if rng.randf() < walker_direction_chance:
				walkers[i].dir = GetRandomDirection()
		
		# Random: Maybe destroy walker?
		for i in range(walkers.size()):
			if rng.randf() < walker_destroy_chance and walkers.size() > 1:
				walkers.remove(i);
				break; # Destroy only one walker per iteration
		
		# Spawn new walkers, with chance
		for i in range(walkers.size()):
			if rng.randf() < walker_spawn_chance and walkers.size() < walker_max_count:
				var walker = Walker.new()
				walker.dir = GetRandomDirection()
				walker.pos = walkers[i].pos
				walkers.append(walker)
	
		# Advance walkers
		for i in range(walkers.size()):
			
			if (walkers[i].pos.x + walkers[i].dir.x >= 1 and 
				walkers[i].pos.x + walkers[i].dir.x < width-1 and
				walkers[i].pos.y + walkers[i].dir.y >= 1 and
				walkers[i].pos.y + walkers[i].dir.y < height-1):
					
					walkers[i].pos += walkers[i].dir
					if grid[walkers[i].pos.x][walkers[i].pos.y] == Tiles.empty:
						grid[walkers[i].pos.x][walkers[i].pos.y] = Tiles.floor
						n_tiles += 1
						
						if float(n_tiles)/float(width*height) >= fill_percent:
							return
		itr += 1
		
func _create_walls():
	
	for x in width:
		for y in height:
			if grid[x][y] == Tiles.floor:
				for neighbor in neighbors4:
					if check_bounds(x, y, neighbor) && grid[x + neighbor[0]][y + neighbor[1]] == Tiles.empty:
						grid[x + neighbor[0]][y + neighbor[1]] = Tiles.wall
			
func _remove_singletons():
	for x in width:
		for y in height:
			if grid[x][y] == Tiles.wall:
				var single = true
				for neighbor in neighbors4:
					if check_bounds(x, y, neighbor) && grid[x + neighbor[0]][y + neighbor[1]] != Tiles.floor:
						single = false
						break
				if single:
					grid[x][y] = Tiles.floor

func check_bounds(x, y, neighbor):
	return x + neighbor[0] >= 0 && y + neighbor[1] >= 0 && y + neighbor[1] < height && x + neighbor[0] < width

func _pad_dirt():
	
	var bfs = []
	var visited = []
	
	for x in width:
		visited.append([])
		for y in height:
			if grid[x][y] == Tiles.wall:
				bfs.append(Vector2(x, y))
				visited[x].append(0)
			else:
				visited[x].append(60000)
	
	while !bfs.empty():
		var position = bfs.pop_front()
		for i in range(neighbors8.size()):
			var next = Vector2(position.x + neighbors8[i][0], position.y + neighbors8[i][1])
			if next.x >= 1 and next.x < width-1 and next.y >= 1 and next.y < height-1 and (
				visited[next.x][next.y] == 60000
				):
				visited[next.x][next.y] = visited[position.x][position.y] + 1
				bfs.append(next)    
	
	for x in width:
		for y in height:
			if x == 0 or y == 0 or x == width-1 or y == height-1:
				continue
			if grid[x][y] == Tiles.floor and visited[x][y] >= 2:
				grid[x][y] = Tiles.dirt
	
func _remove_diagonals(tile_index):
	for x in width:
		for y in height:
			# Check if on edges
			if x == 0 or y == 0 or x == width-1 or y == height-1:
				continue
				
			# If not on edges, make sure all surrounding tiles are floor and this is wall
			var position = Vector2(x, y);
			if grid[position.x][position.y] == tile_index:
				if (grid[position.x - 1][position.y] == Tiles.floor and grid[position.x + 1][position.y] == Tiles.floor and
					grid[position.x][position.y - 1] == Tiles.floor and grid[position.x][position.y + 1] == Tiles.floor):
					grid[position.x][position.y] = Tiles.floor

				# Check if diagonal tile
				if (grid[position.x - 1][position.y] == Tiles.floor and grid[position.x][position.y-1] == Tiles.floor and
					grid[position.x - 1][position.y-1] == tile_index) or (grid[position.x + 1][position.y] == Tiles.floor and grid[position.x][position.y+1] == Tiles.floor and
					grid[position.x + 1][position.y+1] == tile_index) or (grid[position.x + 1][position.y] == Tiles.floor and grid[position.x][position.y-1] == Tiles.floor and
					grid[position.x + 1][position.y-1] == tile_index) or (grid[position.x - 1][position.y] == Tiles.floor and grid[position.x][position.y+1] == Tiles.floor and
					grid[position.x - 1][position.y+1] == tile_index):
					grid[position.x][position.y] = Tiles.floor
	
func _spawn_tiles():
	
	for x in width:
		for y in height:
			match grid[x][y]:
				Tiles.empty:
					wall_tilemap.set_cellv(Vector2(x, y), 0)
				Tiles.floor:
					pass
				Tiles.dirt:
					dirt_tilemap.set_cellv(Vector2(x*2, y*2), 0)
					dirt_tilemap.set_cellv(Vector2(x*2 + 1, y*2), 0)
					dirt_tilemap.set_cellv(Vector2(x*2, y*2 + 1), 0)
					dirt_tilemap.set_cellv(Vector2(x*2 + 1, y*2 + 1), 0)
				Tiles.wall:
					wall_tilemap.set_cellv(Vector2(x, y), 0)
					
	dirt_tilemap.update_bitmask_region()
	wall_tilemap.update_bitmask_region()

func _clear_tilemaps():
	for x in width:
		for y in height:
			dirt_tilemap.clear()
			wall_tilemap.clear()

func _ready():
	rng.randomize()
	_init_walkers()
	_init_grid()
	_clear_tilemaps()
	_create_random_path()
	_create_walls()
	_remove_singletons()
	_pad_dirt()
	_remove_diagonals(Tiles.dirt)
	_spawn_tiles()
	
	
func _input(event):
	if Input.is_key_pressed(KEY_SPACE):
		_init_walkers()
		_init_grid()
		_clear_tilemaps()
		_create_random_path()
		_create_walls()
		_remove_singletons()
		_pad_dirt()        
		_remove_diagonals(Tiles.dirt)
		_spawn_tiles()
