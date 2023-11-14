extends "res://FlappyBird/FlappyBirdMain.gd"

var time = 4
var up_or_down = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	current_scene = "res://FlappyBird/first_difficulty.tscn"
	super._ready()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	beat_counter += delta
	if beat_counter >= 1:
		beat_counter = 0
		beat()
	
func beat():
	print(current_beat)
	current_beat += 1
	if current_beat == 2:
		current_beat = 0
		var stream = get_free_audio_stream()
		stream.set_stream(glock_3_wav)
		stream.play()
		obstacle_movement()
	else:
		var stream = get_free_audio_stream()
		stream.set_stream(glock_1_wav)
		stream.play()
		
	pass

func obstacle_movement():
	print("movement")
	up_or_down = (up_or_down + 1) % 4
	for obstacle in obstacle_list:
		
		var translation_distance = randf_range(100,250)
		if score > 10:
			translation_distance = translation_distance + 100
		elif score > 20:
			translation_distance = translation_distance + 300
				
		if up_or_down <= 1:
			translation_distance = -translation_distance
		obstacle.translate_obstacle(translation_distance)
		print(translation_distance)

	pass
