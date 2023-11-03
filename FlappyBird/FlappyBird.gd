extends Node2D

var camera_instance = load("res://Main/camera_2d.tscn")
var camera : Camera2D
var camera_top_limit : float
var camera_bot_limit : float
var screen_width : float

@onready var jump_count_node = $FlappyBirdUI/LabelContainer/JumpCount
@onready var dash_count_node = $FlappyBirdUI/LabelContainer/DashCount
@onready var score_node = $FlappyBirdUI/LabelContainer/Score

var obstacle_instance = load("res://FlappyBird/obstacle.tscn")
var obstacle_list : Array = []

@export var obstacle_spacing : float = 250
@export_range(200,0,0.1) var obstacle_height_max : float = 100
@export_range (200,0,0.1) var obstacle_height_min : float = 50
@export_range(0,100) var max_difficulty_score : int = 50

var can_player_score : bool = false
var score : int = 0
var obstacle_count : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_player_score == true and $Player.state != $Player.STATES.DASHING:
		can_player_score = false
		add_score(1)
		add_jump(1)
		pass
	pass

func initialize_level():
	if obstacle_height_max < obstacle_height_min:
		var temp = obstacle_height_max
		obstacle_height_max = obstacle_height_min
		obstacle_height_min = temp
	var camera_center = $Player/Camera2D.get_screen_center_position()
	var camera_size = get_viewport_rect().size
	camera_top_limit = camera_center.y - camera_size.y/2
	camera_bot_limit = camera_center.y + camera_size.y/2
	$Player.set_position(camera_center*Vector2(0.33,1))
	$Player.obstacle_spacing = obstacle_spacing
	$Player.set_top_of_screen_y(camera_top_limit)
	
	var player_position_x = $Player.get_global_position().x
	screen_width = get_viewport_rect().size.x
	var obstacle_position_x = player_position_x + obstacle_spacing/2
	while obstacle_position_x < player_position_x + screen_width*2:
		create_obstacle(obstacle_position_x)
		obstacle_position_x += obstacle_spacing

func create_obstacle(obstacle_position_x):
	var obstacle = obstacle_instance.instantiate()
	var opening_height = obstacle_height_max - (obstacle_height_max-obstacle_height_min)*obstacle_count/max_difficulty_score
	obstacle.create_obstacle(obstacle_position_x,camera_top_limit,camera_bot_limit,opening_height)
	if obstacle_count < max_difficulty_score:
		obstacle_count += 1
	obstacle_position_x += obstacle_spacing
	add_child(obstacle)
	obstacle_list.append(obstacle)
	print(obstacle.get_global_position())
	pass

func add_dash(input_int):
	var current_count = int(dash_count_node.get_text())
	current_count += input_int
	dash_count_node.set_text(current_count)

func _on_player_dashed():
	can_player_score = true
	add_dash(-1)
	var last_obstacle_x = obstacle_list[-1].get_global_position().x
	create_obstacle(last_obstacle_x+obstacle_spacing)
	var first_obstacle = obstacle_list[0]
	var first_obstacle_x = first_obstacle.get_global_position().x
	var distance_from_player = first_obstacle_x - $Player.get_global_position().x
	if distance_from_player > 2*screen_width:
		first_obstacle.queue_free()
		
	pass # Replace with function body.
	pass # Replace with function body.

func add_jump(input_int):
	var current_count = int(jump_count_node.get_text())
	current_count += input_int
	jump_count_node.set_text(current_count)
	
func _on_player_jumped():
	add_jump(-1)
	pass # Replace with function body.

func add_score(input_int):
	var current_count = int(score_node.get_text())
	current_count += input_int
	score_node.set_text(current_count)
