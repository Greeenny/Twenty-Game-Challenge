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
var background_list : Array = []
@export var obstacle_spacing : float = 250
@export var obstacle_width : float = 50
@export_range(1,200,0.1) var obstacle_height_max : float = 100
@export_range (1,200,0.1) var obstacle_height_min : float = 50
@export_range(0,100) var max_difficulty_score : int = 50

var can_player_score : bool = false
var score : int = 0
var obstacle_count : int = 0

@export var BPM = 120
var BPS = float(float(60)/float(BPM))
var beat_counter = 0 
var beat = 0
var glock_1_wav = load("res://FlappyBird/706835__groupofseven__glok1.wav")
var glock_2_wav = load("res://FlappyBird/706836__groupofseven__glok2.wav")
var glock_3_wav = load("res://FlappyBird/706834__groupofseven__glok-3.wav")

@onready var audio_stream_player_list = [$AudioStreamPlayer]
# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_level()
	initialize_background()
	score = -1
	add_score(1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	beat_counter += delta
	if beat_counter >= BPS:
		var audio_stream_player = 0
		for stream_player in audio_stream_player_list:
			if stream_player.playing == false:
				audio_stream_player = stream_player
		if typeof(audio_stream_player) == typeof(0):
			audio_stream_player = AudioStreamPlayer.new()
			audio_stream_player_list.append(audio_stream_player)

		
		#print(beat_counter)
		beat_counter = 0
		if beat == 3:
			audio_stream_player.stream = glock_1_wav
			audio_stream_player.play()
			beat = 0
			for obstacle in obstacle_list:
				if randi_range(0,1) == 0:
					obstacle.chomp_obstacle()
				else:
					var translate_amount = randf_range(200,500)
					if obstacle.edge == obstacle.EDGE.TOP:
						translate_amount = -abs(translate_amount)
					elif obstacle.edge == obstacle.EDGE.BOTTOM:
						translate_amount = abs(translate_amount)
					obstacle.translate_obstacle(translate_amount)
		else:
			beat += 1
			audio_stream_player.stream = glock_3_wav
			audio_stream_player.play()
			
		#print("beat")
		
	if can_player_score == true and $Player.state != $Player.STATE.DASHING:
		can_player_score = false
		add_score(1)
		pass
	pass
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
	var obstacle_position_x = player_position_x + obstacle_spacing*5/8
	
	while obstacle_position_x < player_position_x + camera_width*2:
		create_obstacle(obstacle_position_x)
		obstacle_position_x += obstacle_spacing
		

func set_score(input_int):
	var path_to_score_sprite = "res://FlappyBird/Sprites/"
	var score_split_into_strings = str(score).split()
	for number in score_split_into_strings:
		var sprite_path = path_to_score_sprite + number +".png"
		var sprite = Sprite2D.new()
		sprite.set_texture(load(sprite_path))
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

	pass

func _on_player_dashed(): 
	can_player_score = true
	
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
	
func _on_player_jumped():
	pass # Replace with function body.

func add_score(input_int):
	score += input_int
	var path_to_score_sprite = "res://FlappyBird/Sprites/"
	var score_split_into_strings = Array(str(score).split())
	var score_nodes = $FlappyBirdUI/ScoreContainer.get_children()
	while not score_split_into_strings.is_empty():
		var score_texture_rect = TextureRect
		var texture = load(path_to_score_sprite+score_split_into_strings.pop_front()+".png")
		if not score_nodes.is_empty():
			score_texture_rect = score_nodes.pop_front()
		else:
			score_texture_rect = TextureRect.new()
			$FlappyBirdUI/ScoreContainer.add_child(score_texture_rect)
			
		score_texture_rect.set_texture(texture)
		
		


func _on_player_dead():
	print("Player has died!")
	var score_file = FileAccess.open("res://FlappyBird/score.json",FileAccess.READ)
	var score_json = JSON.parse_string(score_file.get_as_text())
	score_file.close()

	var high_score = score_json["high_score"]
	print(high_score)
	if high_score < score:
		score_file = FileAccess.open("res://FlappyBird/score.json",FileAccess.WRITE)
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
		$FlappyBirdUI/GameOverScreen/HighScoreContainer.add_child(hs_digit)
	
	for obstacle in obstacle_list:
		obstacle.queue_free()
	obstacle_list.clear()
	$FlappyBirdUI/GameOverScreen.show()
	pass # Replace with function body.
