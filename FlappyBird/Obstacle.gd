extends Area2D

var top_of_screen_y : float
var bot_of_screen_y : float
var obstacle_width : float = 50
var opening_position : Vector2

var initialized : bool = false

var color : Color = Color.MEDIUM_PURPLE
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
	pass
	
func create_obstacle(x_position,top_of_screen_limit,bot_of_screen_limit,opening_height):
	var camera_center = get_viewport().get_camera_2d().get_screen_center_position()
	var camera_size = get_viewport_rect().size
	top_of_screen_y = camera_center.y - camera_size.y/2
	set_global_position(Vector2(x_position,top_of_screen_y))
	top_of_screen_y = 0
	bot_of_screen_y = camera_size.y
	position_obstacle(opening_height)
	initialized = true
	
	
	
func position_obstacle(opening_height):

	opening_position = Vector2(0,randf_range(top_of_screen_y+opening_height, bot_of_screen_y-opening_height))
	var top_obstacle_bottom_edge_y = opening_position.y - opening_height/2
	var top_obstacle_size = Vector2(obstacle_width, top_obstacle_bottom_edge_y - top_of_screen_y)
	var top_obstacle_position = Vector2(0,top_obstacle_bottom_edge_y - top_obstacle_size.y/2)

	$Top.shape.set_size(top_obstacle_size)
	$Top.set_position(top_obstacle_position)
	
	#Here we find the scale as we want the sprite to be the same size as the collision box,
	#We know our sprite currently has size x, and x * scale = collision box size, therefore
	# collision box size / x = scale. Apply scale to x... ezpz
	var top_scale_to_apply = top_obstacle_size/$Top/TopSprite.get_rect().size
	$Top/TopSprite.apply_scale(top_scale_to_apply)
#	$Top/TopSprite.set_region_rect(Rect2(Vector2(0,top_obstacle_position),Vector2(obstacle_width,top_obstacle_size_y)))
	
	var bot_obstacle_top_edge_y = opening_position.y + opening_height/2
	var bot_obstacle_size = Vector2(obstacle_width,bot_of_screen_y - bot_obstacle_top_edge_y)
	var bot_obstacle_position = Vector2(0,bot_obstacle_top_edge_y + bot_obstacle_size.y/2)
	$Bottom.shape.set_size(bot_obstacle_size)
	$Bottom.set_position(bot_obstacle_position)
	var bot_scale_to_apply = bot_obstacle_size/$Bottom/BottomSprite.get_rect().size
	$Bottom/BottomSprite.apply_scale(bot_scale_to_apply)
	pass


func _on_mouse_entered():
	print("in")
	pass # Replace with function body.


func _on_mouse_exited():
	print('out')
	pass # Replace with function body.






func _on_body_entered(body):
	pass # Replace with function body.


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("Body shape entered")
	print(body_rid)
	pass # Replace with function body.
