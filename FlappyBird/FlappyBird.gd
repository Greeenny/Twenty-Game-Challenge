extends Node2D

var camera_instance = load("res://Main/camera_2d.tscn")
var camera : Camera2D
var camera_top_limit : float
var camera_bot_limit : float
@onready var camera_width = $Player.camera_width


@onready var jump_count_node = $FlappyBirdUI/LabelContainer/JumpCount
@onready var score_node = $FlappyBirdUI/LabelContainer/Score

var obstacle_instance = load("res://FlappyBird/obstacle.tscn")
var obstacle_list : Array = []

@export var obstacle_spacing : float = 250
@export_range(1,200,0.1) var obstacle_height_max : float = 100
@export_range (1,200,0.1) var obstacle_height_min : float = 50
@export_range(0,100) var max_difficulty_score : int = 50

var can_player_score : bool = false
var score : int = 0
var obstacle_count : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_level()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_player_score == true and $Player.state != $Player.STATE.DASHING:
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
	camera = $Player/Camera2D
	camera.make_current()
	var camera_center = camera.get_screen_center_position()


	$Player.obstacle_spacing = obstacle_spacing
	var player_position_x = $Player.get_global_position().x
	var obstacle_position_x = player_position_x + obstacle_spacing/2
	
	while obstacle_position_x < player_position_x + camera_width*2:
		create_obstacle(obstacle_position_x)
		obstacle_position_x += obstacle_spacing

func create_obstacle(obstacle_position_x):
	var obstacle = obstacle_instance.instantiate()
	add_child(obstacle)
	
	var opening_height = obstacle_height_max - (obstacle_height_max-obstacle_height_min)*obstacle_count/max_difficulty_score
	obstacle.create_obstacle(obstacle_position_x,camera_top_limit,camera_bot_limit,opening_height)
	if obstacle_count < max_difficulty_score:
		obstacle_count += 1
	obstacle_position_x += obstacle_spacing

	obstacle_list.append(obstacle)
	pass

func _on_player_dashed():
	can_player_score = true
	var last_obstacle_x = obstacle_list[-1].get_global_position().x
	create_obstacle(last_obstacle_x+obstacle_spacing)
	var first_obstacle = obstacle_list[0]
	var first_obstacle_x = first_obstacle.get_global_position().x
	var distance_from_player = first_obstacle_x - $Player.get_global_position().x
	if distance_from_player < -2*camera_width:
		first_obstacle.queue_free()
		obstacle_list.pop_front()

	pass # Replace with function body.

func add_jump(input_int):
	var current_count = int(jump_count_node.get_text())
	current_count += input_int
	jump_count_node.set_text(str(current_count))
	
func _on_player_jumped():
	add_jump(-1)
	pass # Replace with function body.

func add_score(input_int):
	var current_count = int(score_node.get_text())
	current_count += input_int
	score_node.set_text(str(current_count))
