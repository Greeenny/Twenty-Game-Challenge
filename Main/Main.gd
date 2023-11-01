extends Node2D

var camera_instance = load("res://Main/camera_2d.tscn")
var camera : Camera2D

var games_menu_instance = load("res://Main/games_menu.tscn")
var current_game : Node2D
var last_selected_game_path : String


enum GAME_STATE{SELECTOR_OPEN,GAME_RUNNING}
var game_state : int

func _ready():
	create_games_menu()
	pass # Replace with function body.

func _process(delta):
	if game_state == GAME_STATE.GAME_RUNNING:
		if Input.is_action_just_pressed("escape_key"):
			current_game.queue_free()
			create_games_menu()
		elif Input.is_action_just_pressed("tilde_key"):
			current_game.queue_free()
			_on_games_menu_load_game(last_selected_game_path)

func create_games_menu():
	camera = camera_instance.instantiate()
	add_child(camera)
	var games_menu_node = games_menu_instance.instantiate()
	$UI.add_child(games_menu_node)
	games_menu_node.connect("load_game",_on_games_menu_load_game)
	game_state = GAME_STATE.SELECTOR_OPEN


func _on_games_menu_load_game(game_path):
	if game_state == GAME_STATE.SELECTOR_OPEN:
		camera.queue_free()
		$UI/GamesMenu.queue_free()
	last_selected_game_path = game_path
	current_game = load(game_path).instantiate()
	add_child(current_game)
	game_state = GAME_STATE.GAME_RUNNING
	pass # Replace with function body.
