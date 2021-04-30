extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var neighbor_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func set_neighbors(neighbors):
    self.neighbor_list = neighbors
    
    
func test_neighbors():
    var neighbor_count = 0
    for i in range(len(neighbor_list)):
        if neighbor_list[i] != null && neighbor_list[i].visible:
            neighbor_count += 1
    if self.visible && neighbor_count < 2:
        return false
    elif self.visible && neighbor_count > 3:
        return false
    elif not self.visible && neighbor_count == 3:
        return true
    elif self.visible && (neighbor_count == 2 || neighbor_count == 3):
        return true
    else:
        return false
            

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
