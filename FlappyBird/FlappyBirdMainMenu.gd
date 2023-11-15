extends Node2D

var background_list : Array = []
var difficulty_selection = {0:"res://FlappyBird/first_difficulty.tscn"}

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_background()
	var dir = DirAccess.open("user://FlappyMadness")
	if dir:
		pass
	else:
		DirAccess.make_dir_absolute("user://FlappyMadness")

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initialize_background():
	var path_to_background_sprite = "res://FlappyBird/Sprites/background-day.png"
	var viewport_rect = get_viewport_rect()
	var viewport_center_x = viewport_rect.get_center().x
	var background_position = Vector2(viewport_center_x - viewport_rect.size.x*2,viewport_rect.size.y/2)
	while background_position.x < viewport_center_x + viewport_rect.size.x*2:
		var background_sprite = Sprite2D.new()
		$BackgroundSprites.add_child(background_sprite)
		background_sprite.set_global_position(background_position)
		background_sprite.set_texture(load(path_to_background_sprite))
		background_sprite.z_index = -1
		background_list.append(background_sprite)
		background_position.x += background_sprite.get_rect().size.x
	pass



func _on_play_game_pressed():
	get_tree().change_scene_to_file(difficulty_selection[0])
	var difficulty_button = $UI/VBoxContainer/Difficulty
	if difficulty_button.visible == true:
		difficulty_button.hide()
	elif difficulty_button.visible == false:
		difficulty_button.show()
	pass # Replace with function body.



func _on_difficulty_item_selected(index):
	if index in difficulty_selection:
		get_tree().change_scene_to_file(difficulty_selection[index])
	pass # Replace with function body.
