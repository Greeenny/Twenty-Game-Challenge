extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	queue_redraw()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	draw_circle(Vector2.ZERO,10.0,Color.WHITE)
