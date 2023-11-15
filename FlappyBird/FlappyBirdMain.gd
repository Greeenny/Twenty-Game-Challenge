extends Node2D

var current_scene : String = "res://FlappyBird/flappy_bird_main_menu.tscn"

var running : bool = true
#Music
@export var BPM : float = 120
@onready var audio_stream_list : Array = [$AudioStreamPlayer]

var beat_counter = 0 
var current_beat = 0
var glock_1_wav = load("res://FlappyBird/706835__groupofseven__glok1.wav")
var glock_2_wav = load("res://FlappyBird/706836__groupofseven__glok2.wav")
var glock_3_wav = load("res://FlappyBird/706834__groupofseven__glok-3.wav")

#Obstacles
var obstacle_instance = load("res://FlappyBird/obstacle.tscn")
var obstacle_list : Array = []
var background_list : Array = []
@export var obstacle_spacing : float = 250
@export var obstacle_width : float = 50
@export_range(1,200,0.1) var obstacle_height_max : float = 100
@export_range (1,200,0.1) var obstacle_height_min : float = 50
@export_range(0,100) var max_difficulty_score : int = 50

var can_player_score : bool = false
var score : int = -1
var obstacle_count : int = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_level()
	initialize_background()
	add_score(1)
	
	pass # Replace with function body.
func beat():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var SPB = float(60)/BPM
	beat_counter += delta
	if beat_counter >= SPB and running:
		beat_counter = 0
		beat()
		


	if Input.is_action_just_pressed("reset"):
		get_tree().change_scene_to_file(current_scene)
	if Input.is_action_just_pressed("escape_key"):
		get_tree().change_scene_to_file("res://FlappyBird/flappy_bird_main_menu.tscn")
		pass
	if can_player_score == true and $Player.state != $Player.STATE.DASHING:
		can_player_score = false
		add_score(1)
		pass
		
func initialize_level():
	if obstacle_height_max < obstacle_height_min:
		var temp = obstacle_height_max
		obstacle_height_max = obstacle_height_min
		obstacle_height_min = temp
	var camera = $Player/Camera2D
	camera.make_current()
	var camera_center = camera.get_screen_center_position()
	var viewport_rect = get_viewport_rect()
	var viewport_width = viewport_rect.size.x

	$Player.obstacle_spacing = obstacle_spacing
	var player_position_x = $Player.get_global_position().x
	var obstacle_position_x = player_position_x + obstacle_spacing*5/8
	
	while obstacle_position_x < player_position_x + viewport_width*2:
		create_obstacle(obstacle_position_x)
		obstacle_position_x += obstacle_spacing
		
func initialize_background():
	var path_to_background_sprite = "res://FlappyBird/Sprites/background-day.png"
	var viewport_rect = get_viewport_rect()
	var viewport_center_x = viewport_rect.get_center().x
	var viewport_width = viewport_rect.size.x
	var background_position = $Player.get_global_position() + Vector2(viewport_center_x - viewport_width,0)
	while background_position.x < viewport_center_x + viewport_width*2:
		var background_sprite = Sprite2D.new()
		$BackgroundSprites.add_child(background_sprite)
		background_sprite.set_global_position(background_position)
		background_sprite.set_texture(load(path_to_background_sprite))
		background_sprite.z_index = -1
		background_list.append(background_sprite)
		background_position.x += background_sprite.get_rect().size.x
	pass
	
func create_obstacle(obstacle_position_x):
	var obstacle = obstacle_instance.instantiate()
	add_child(obstacle)
	var opening_height : float
	if obstacle_count < max_difficulty_score:
		opening_height = obstacle_height_max - (obstacle_height_max-obstacle_height_min)*obstacle_count/max_difficulty_score
	else:
		opening_height = obstacle_height_min
	obstacle.initialize_obstacle(obstacle_position_x,obstacle_width,opening_height)
	if obstacle_count < max_difficulty_score:
		obstacle_count += 1
	obstacle_position_x += obstacle_spacing

	obstacle_list.append(obstacle)
	
func _on_player_dashed(): 
	can_player_score = true
	var camera_width = get_viewport_rect().size.x
	var first_background = background_list[0]
	var bg_distance_from_player = first_background.get_global_position().x - $Player.get_global_position().x
	if bg_distance_from_player < -camera_width:
		first_background.set_global_position(background_list[-1].get_global_position() + Vector2(first_background.get_rect().size.x,0))
		background_list.append(first_background)
		background_list.remove_at(0)

	var last_obstacle_x = obstacle_list[-1].get_global_position().x
	create_obstacle(last_obstacle_x+obstacle_spacing)
	var first_obstacle = obstacle_list[0]
	var first_obstacle_x = first_obstacle.get_global_position().x
	var distance_from_player = first_obstacle_x - $Player.get_global_position().x
	if distance_from_player < -camera_width:
		first_obstacle.queue_free()
		obstacle_list.pop_front()

	pass # Replace with function body.
func add_score(input_int):
	score += input_int
	var path_to_score_sprite = "res://FlappyBird/Sprites/"
	var score_split_into_strings = Array(str(score).split())
	var score_nodes = $UI/ScoreContainer.get_children()
	while not score_split_into_strings.is_empty():
		var score_texture_rect = TextureRect
		var texture = load(path_to_score_sprite+score_split_into_strings.pop_front()+".png")
		if not score_nodes.is_empty():
			score_texture_rect = score_nodes.pop_front()
		else:
			score_texture_rect = TextureRect.new()
			$UI/ScoreContainer.add_child(score_texture_rect)
		score_texture_rect.set_texture(texture)
		


func _on_player_dead():
	running = false
	print("Player has died!")
	var score_file = FileAccess.open("user://FlappyMadness/score.json",FileAccess.READ)
	var high_score : int
	var score_json : Dictionary = {}
	if score_file:
		score_json = JSON.parse_string(score_file.get_as_text())
		score_file.close()
		high_score = score_json["high_score"]
	else:
		high_score = 0
	if high_score < score:
		score_file = FileAccess.open("user://FlappyMadness/score.json",FileAccess.WRITE)
		score_json['high_score'] = score
		high_score = score
		score_file.store_string(JSON.stringify(score_json)) 
		score_file.close()
		
	var path_to_score_sprite = "res://FlappyBird/Sprites/"
	var high_score_split = Array(str(high_score).split())
	for score in high_score_split:
		var hs_digit = TextureRect.new()
		var texture = load(path_to_score_sprite+score+".png")
		hs_digit.set_texture(texture)
		hs_digit.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		$UI/GameOverScreen/HighScoreContainer.add_child(hs_digit)
	
	for obstacle in obstacle_list:
		obstacle.queue_free()
	obstacle_list.clear()
	$UI/GameOverScreen.show()
	pass # Replace with function body.


func get_free_audio_stream():
	for stream in audio_stream_list:
		if stream.playing == false:
			return stream
	var new_stream = AudioStreamPlayer
	audio_stream_list.append(new_stream)
	add_child(new_stream)
	return new_stream
	
