extends Node2D

@export var tilemap  : TileMapLayer
@export var player   : CharacterBody2D
@export var minimap  : TextureRect        # <- TextureRect in UI
@export var minimap_scale := 3            # pixels per cell on the minimap

const TILE_SIZE       := 16
const DUNGEON_WIDTH   := 80
const DUNGEON_HEIGHT  := 80

enum TileType { EMPTY, FLOOR, WALL }

var dungeon_grid: Array = []
var _minimap_base: Image = null          # cached, scaled base (no player dot)

func _ready() -> void:
	create_dungeon()

func _physics_process(_delta: float) -> void:
	_update_minimap_player_dot()

# ------------------ Generation ------------------

func generate_dungeon() -> Array[Rect2]:
	dungeon_grid = []
	for y in range(DUNGEON_HEIGHT):
		dungeon_grid.append([])
		for x in range(DUNGEON_WIDTH):
			dungeon_grid[y].append(TileType.EMPTY)

	var rooms: Array[Rect2] = []
	var max_attempts := 100
	var tries := 0

	while rooms.size() < 10 and tries < max_attempts:
		var w := randi_range(8, 16)
		var h := randi_range(8, 16)
		var x := randi_range(1, DUNGEON_WIDTH - w - 1)
		var y := randi_range(1, DUNGEON_HEIGHT - h - 1)
		var room := Rect2(x, y, w, h)

		var overlaps := false
		for other in rooms:
			if room.grow(1).intersects(other):
				overlaps = true
				break

		if !overlaps:
			rooms.append(room)
			for iy in range(y, y + h):
				for ix in range(x, x + w):
					dungeon_grid[iy][ix] = TileType.FLOOR

			if rooms.size() > 1:
				var prev := rooms[rooms.size() - 2].get_center()
				var curr := room.get_center()
				carve_corridor(prev, curr)

		tries += 1

	return rooms

func render_dungeon() -> void:
	tilemap.clear()
	for y in range(DUNGEON_HEIGHT):
		for x in range(DUNGEON_WIDTH):
			var tile = dungeon_grid[y][x]
			match tile:
				TileType.FLOOR: tilemap.set_cell(Vector2i(x, y), 0, Vector2i(8, 1))
				TileType.WALL:  tilemap.set_cell(Vector2i(x, y), 0, Vector2i(1, 0))

	_build_minimap_base() # <- build the image for the UI minimap

func carve_corridor(from: Vector2, to: Vector2, width: int = 2) -> void:
	var min_w := -width / 2
	var max_w :=  width / 2

	if randf() < 0.5:
		for x in range(int(min(from.x, to.x)), int(max(from.x, to.x)) + 1):
			for o in range(min_w, max_w + 1):
				var y := int(from.y + o)
				if is_in_bounds(x, y):
					dungeon_grid[y][x] = TileType.FLOOR
		for y in range(int(min(from.y, to.y)), int(max(from.y, to.y)) + 1):
			for o in range(min_w, max_w + 1):
				var x := int(to.x + o)
				if is_in_bounds(x, y):
					dungeon_grid[y][x] = TileType.FLOOR
	else:
		for y in range(int(min(from.y, to.y)), int(max(from.y, to.y)) + 1):
			for o in range(min_w, max_w + 1):
				var x := int(from.x + o)
				if is_in_bounds(x, y):
					dungeon_grid[y][x] = TileType.FLOOR
		for x in range(int(min(from.x, to.x)), int(max(from.x, to.x)) + 1):
			for o in range(min_w, max_w + 1):
				var y := int(to.y + o)
				if is_in_bounds(x, y):
					dungeon_grid[y][x] = TileType.FLOOR

func is_in_bounds(x: int, y: int) -> bool:
	return x >= 0 and y >= 0 and x < DUNGEON_WIDTH and y < DUNGEON_HEIGHT

func add_walls() -> void:
	for y in range(DUNGEON_HEIGHT):
		for x in range(DUNGEON_WIDTH):
			if dungeon_grid[y][x] == TileType.FLOOR:
				for dy in range(-1, 2):
					for dx in range(-1, 2):
						var nx := x + dx
						var ny := y + dy
						if is_in_bounds(nx, ny) and dungeon_grid[ny][nx] == TileType.EMPTY:
							dungeon_grid[ny][nx] = TileType.WALL

func place_player(rooms: Array[Rect2]) -> void:
	player.position = rooms.pick_random().get_center() * TILE_SIZE

func create_dungeon() -> void:
	place_player(generate_dungeon())
	add_walls()
	render_dungeon()

# ------------------ Minimap (TextureRect) ------------------

func _build_minimap_base() -> void:
	# Build a 1:1 cell image first (1 pixel per dungeon cell)
	var img := Image.create(DUNGEON_WIDTH, DUNGEON_HEIGHT, false, Image.FORMAT_RGBA8)
	for y in range(DUNGEON_HEIGHT):
		for x in range(DUNGEON_WIDTH):
			var tile = dungeon_grid[y][x]
			var c: Color
			match tile:
				TileType.FLOOR: c = Color(1, 1, 1, 1)     # white
				TileType.WALL:  c = Color(0.5, 0.5, 0.5) # gray
				_:              c = Color(0, 0, 0, 0)     # transparent
			img.set_pixel(x, y, c)

	# Pre-scale once for cheap per-frame updates
	if minimap_scale > 1:
		img.resize(DUNGEON_WIDTH * minimap_scale, DUNGEON_HEIGHT * minimap_scale, Image.INTERPOLATE_NEAREST)

	_minimap_base = img
	# Push initial texture (without player dot yet)
	minimap.texture = ImageTexture.create_from_image(_minimap_base)

func _update_minimap_player_dot() -> void:
	if _minimap_base == null:
		return

	# Duplicate pre-scaled base and draw a small red square where the player is
	var img := _minimap_base.duplicate()

	# Convert player world → tile coordinate using the dungeon TileMap
	var cell: Vector2i = tilemap.local_to_map(tilemap.to_local(player.global_position))
	cell.x = clamp(cell.x, 0, DUNGEON_WIDTH - 1)
	cell.y = clamp(cell.y, 0, DUNGEON_HEIGHT - 1)

	var px := cell.x * minimap_scale
	var py := cell.y * minimap_scale
	for yy in range(minimap_scale):
		for xx in range(minimap_scale):
			img.set_pixel(px + xx, py + yy, Color(1, 0, 0, 1)) # red dot

	minimap.texture = ImageTexture.create_from_image(img)
