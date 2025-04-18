extends Node2D


@onready var windows_size = DisplayServer.window_get_size()
@onready var sprite = $Sprite2D
@onready var random_position: Vector2 = Vector2(randi_range(0, windows_size.x), randi_range(0, windows_size.y))
@onready var move_sprite: bool = false

func _ready():
	get_tree().get_root().set_transparent_background(true)
	DisplayServer.window_set_size(Vector2i(100, 100))
	sprite.position = Vector2(50, 50)
	
	print(windows_size)
	print(random_position)

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		get_tree().quit()

	if move_sprite:
		DisplayServer.window_set_position(get_viewport().get_mouse_position())
		
	# if sprite.position.x <= random_position.x:
	# 	sprite.position.x += 10
	
	# if sprite.position.x >= random_position.x:
	# 	sprite.position.x -= 10
	
	# if sprite.position.y <= random_position.y:
	# 	sprite.position.y += 10
	
	# if sprite.position.y >= random_position.y:
	# 	sprite.position.y -= 10

	# if sprite.position == random_position:
	# 	print("igual")


func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			move_sprite = !move_sprite
