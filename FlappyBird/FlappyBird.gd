extends Node2D

var camera_instance = load("res://Main/camera_2d.tscn")
var camera : Camera2D
# Called when the node enters the scene tree for the first time.
func _ready():
	camera = camera_instance.instantiate()
	add_child(camera)
	var camera_center = $Camera2D.get_screen_center_position()
	var camera_size = $Camera2D.get_viewport().get_visible_rect().size
	var top_limit = camera_center.y - camera_size.y/2
	var bot_limit = camera_center.y + camera_size.y/2
	$Player.set_position(camera_center*Vector2(0.33,1))
	$Player.set_top_of_screen_y(top_limit)
	var x_position = camera_center.x*2*3/4
	var opening_height = 50
	$Obstacle.create_obstacle(x_position,top_limit,bot_limit,opening_height)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

