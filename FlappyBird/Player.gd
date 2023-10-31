extends CharacterBody2D

@export var color : Color

func _physics_process(delta):

	move_and_slide()

func _draw():
	draw_circle(Vector2.ZERO,10.0,color)
