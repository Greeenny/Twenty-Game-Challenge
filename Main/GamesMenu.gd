extends VBoxContainer

signal load_game(game_path)
var games_list : Dictionary = {
	"Flappy Bird" : "res://FlappyBird/flappy_bird.tscn"
}


# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_selector()
	pass # Replace with function body.

func initialize_selector():
	for game_name in games_list:
		var new_button = Button.new()
		new_button.text = game_name
		new_button.connect("pressed", _on_button_pressed.bind(new_button))
		add_child(new_button)

func _on_button_pressed(button_pressed):
	var game_name = button_pressed.text
	var game_path = games_list[game_name]
	emit_signal("load_game",game_path)
	pass # Replace with function body.
