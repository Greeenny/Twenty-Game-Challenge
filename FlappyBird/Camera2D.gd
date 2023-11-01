extends Camera2D

@export var debug_mode : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if debug_mode:
		if Input.is_action_just_pressed("up"):
			set_global_position(get_global_position() + Vector2(0,-100))
			
		if Input.is_action_just_pressed("down"):
			set_global_position(get_global_position() + Vector2(0,100))
		if Input.is_action_just_pressed("left"):
			set_global_position(get_global_position() + Vector2(-100,0))
		if Input.is_action_just_pressed("right"):
			set_global_position(get_global_position() + Vector2(100,0))
	pass
