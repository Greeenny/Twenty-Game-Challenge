extends Node2D

var UI_node : CanvasLayer
var draw_temp = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	var camera_center = $Camera2D.get_screen_center_position()
	var camera_size = $Camera2D.get_viewport().get_visible_rect().size
	var top_limit = camera_center.y - camera_size.y/2
	var bot_limit = camera_center.y + camera_size.y/2
	var x_position = 500
	var opening_height = 50
	$Obstacle.create_obstacle(x_position,top_limit,bot_limit,opening_height)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
