extends Node2D

@export var column_spacing : float = 500
@export var initial_opening_height : float = 100
var current_opening_height : float = initial_opening_height
var column_x : float
var camera_instance = load("res://Main/camera_2d.tscn")
var camera : Camera2D
var camera_offset_from_player : float = 0
var camera_center : Vector2
var camera_size : Vector2
var top_viewport_limit : float 
var bot_viewport_limit : float

var initialized : bool = false
var obstacle_instance = load("res://FlappyBird/obstacle.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_obstacles()

func initialize_obstacles():
	camera = $Camera2D
	camera_center = camera.get_screen_center_position()
	camera_size = camera.get_viewport().get_visible_rect().size
	$Player.set_position(camera_center)
	camera_offset_from_player = camera_size.x / 6
	top_viewport_limit = camera_center.y - camera_size.y/2
	bot_viewport_limit = camera_center.y + camera_size.y/2
	var x_position = camera_center.x*2*3/4
	$Player.set_top_of_screen_y(top_viewport_limit)
	$Player.set_column_spacing(column_spacing)
	column_x = $Player.get_position().x + column_spacing/2
	initialized = true
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if initialized == true:
		camera.set_position(Vector2($Player.get_position().x++camera_offset_from_player,camera.get_position().y))
		camera_center = camera.get_screen_center_position()
		while column_x <= camera_center.x + camera_size.x/2:

			var obstacle = obstacle_instance.instantiate()
			var opening_height = randf_range(current_opening_height,$Player/Collision.shape.radius*3)
			obstacle.create_obstacle(column_x,top_viewport_limit,bot_viewport_limit,opening_height)
			add_child(obstacle)
			if current_opening_height > $Player/Collision.shape.radius*3:
				current_opening_height = current_opening_height*.95
			column_x += column_spacing
			print(column_x)
	pass

