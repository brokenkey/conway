extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var map_width = 48
var map_height = 48
var tile_size = 16
var map = {Vector2(0,0): false}
var tile = preload("res://tile.tscn")
var paused = true
var speed_timer = Timer.new()
var speed_paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
    speed_timer.connect("timeout", self, "_on_timeout")
    speed_timer.start(1)
    add_child(speed_timer)
    get_node("CheckButton").connect("toggled", self, "_time_toggled")
    for i in range(map_width):
        for j in range(map_height):
            var this_tile = tile.instance()
            this_tile.position = Vector2(i * tile_size, j * tile_size)
            this_tile.visible = false
            map[Vector2(i, j)] = this_tile
            add_child(this_tile)
    for i in range(map_width):
        for j in range(map_height):
            if i == 0 and j == 0:
                map[Vector2(i, j)].set_neighbors([null, 
                                                  null, 
                                                  null, 
                                                  null, 
                                                  map[Vector2(i + 1, j)], 
                                                  null, 
                                                  map[Vector2(i, j + 1)], 
                                                  map[Vector2(i + 1, j + 1)]])
            elif i == 0 and j == map_height - 1:
                map[Vector2(i, j)].set_neighbors([null,                       #0
                                                  map[Vector2(i, j - 1)],     #1
                                                  map[Vector2(i + 1, j - 1)], #2
                                                  null,                       #3
                                                  map[Vector2(i + 1, j)],     #4
                                                  null,                       #5
                                                  null,                       #6
                                                  null])                      #7
            elif i == map_width - 1 and j == 0:
                map[Vector2(i, j)].set_neighbors([null,                       #0
                                                  null,                       #1
                                                  null,                       #2
                                                  map[Vector2(i - 1, j)],     #3
                                                  null,                       #4
                                                  map[Vector2(i - 1, j + 1)], #5
                                                  map[Vector2(i, j + 1)],     #6
                                                  null])                      #7
            elif i == map_width - 1 and j == map_height - 1:
                map[Vector2(i, j)].set_neighbors([map[Vector2(i - 1, j - 1)], #0
                                                  map[Vector2(i, j - 1)],     #1
                                                  null,                       #2
                                                  map[Vector2(i - 1, j)],     #3
                                                  null,                       #4
                                                  null,                       #5
                                                  null,                       #6
                                                  null])                      #7
            elif i == 0:
                map[Vector2(i, j)].set_neighbors([null, #0
                                                  map[Vector2(i, j - 1)],     #1
                                                  map[Vector2(i + 1, j -1)],                       #2
                                                  null,                       #3
                                                  map[Vector2(i + 1, j)],     #4
                                                  null,                       #5
                                                  map[Vector2(i, j + 1)],     #6
                                                  map[Vector2(i + 1, j + 1)]])#7
            elif j == 0:
                map[Vector2(i, j)].set_neighbors([null, #0
                                                  null,     #1
                                                  null,                       #2
                                                  map[Vector2(i - 1, j)],                       #3
                                                  map[Vector2(i + 1, j)],     #4
                                                  map[Vector2(i - 1, j + 1)],                       #5
                                                  map[Vector2(i, j + 1)],     #6
                                                  map[Vector2(i + 1, j + 1)]])#7
            elif i == map_width - 1:
                map[Vector2(i, j)].set_neighbors([map[Vector2(i - 1, j - 1)], #0
                                                  map[Vector2(i, j - 1)],     #1
                                                  null,                       #2
                                                  map[Vector2(i - 1, j)],                       #3
                                                  null,     #4
                                                  map[Vector2(i - 1, j + 1)],                       #5
                                                  map[Vector2(i, j + 1)],     #6
                                                  null])#7
            elif j == map_height - 1:
                map[Vector2(i, j)].set_neighbors([map[Vector2(i - 1, j - 1)], #0
                                                  map[Vector2(i, j - 1)],     #1
                                                  map[Vector2(i + 1, j -1)],                       #2
                                                  map[Vector2(i - 1, j)],                       #3
                                                  map[Vector2(i + 1, j)],     #4
                                                  null,                       #5
                                                  null,     #6
                                                  null])#7
            else:
                map[Vector2(i, j)].set_neighbors([map[Vector2(i - 1, j - 1)], #0
                                                  map[Vector2(i, j - 1)],     #1
                                                  map[Vector2(i + 1, j -1)],                       #2
                                                  map[Vector2(i - 1, j)],                       #3
                                                  map[Vector2(i + 1, j)],     #4
                                                  map[Vector2(i - 1, j + 1)],                       #5
                                                  map[Vector2(i, j + 1)],     #6
                                                  map[Vector2(i + 1, j + 1)]])#7
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
func _on_timeout():
    speed_paused = false
    
func _time_toggled(thingy):
    paused = not paused
    if not paused:
        speed_paused = false

func _process(delta):
    if Input.is_mouse_button_pressed(BUTTON_LEFT):
        var place = get_global_mouse_position() / Vector2(tile_size, tile_size)
        place.x = int(place.x)
        place.y = int(place.y)
        if place.x > 0 and place.y > 0 and place.x < map_width and place.y < map_height:
            map[place].visible = not map[place].visible

func _physics_process(delta):
    if not self.paused && not speed_paused:
        var new_map = map.duplicate()
        for i in range(map_width):
            for j in range(map_height):
                new_map[Vector2(i, j)] = map[Vector2(i, j)].test_neighbors()
        for i in range(map_width):
            for j in range(map_height):
                map[Vector2(i, j)].visible = new_map[Vector2(i, j)]
                speed_timer.start(1.0 / get_node("VSlider").value)
                speed_paused = true