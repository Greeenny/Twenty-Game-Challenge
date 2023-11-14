extends "res://FlappyBird/FlappyBirdMain.gd"

var time = 4
var up_or_down = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	current_scene = "res://FlappyBird/first_difficulty.tscn"
	BPM = 120
	super._ready()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	BPM = 120 + score/25*60
	if score > 25:
		BPM = 180
	super._process(delta)
	
func beat():
	print(current_beat)
	current_beat += 1
	if current_beat == 4:
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
		if score >= 10 and score < 20:
			BPM = 180
			translation_distance = translation_distance + 100
		elif score >= 20:
			BPM = 240
			translation_distance = translation_distance + 300
				
		if up_or_down <= 1:
			translation_distance = -translation_distance
		obstacle.translate_obstacle(translation_distance)
		print(translation_distance)

	pass
