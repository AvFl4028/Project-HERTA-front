extends Node2D

@onready var https_request = Request.new("http://127.0.0.1:8000")
@onready var label = $Label
@onready var msg = $LineEdit
@onready var img = $TextureRect
@onready var window_size = DisplayServer.window_get_size()

@onready var img_position_x = (window_size.x - img.size.x) / 2
@onready var img_position_y = (window_size.y - img.size.y) / 4

@onready var msg_position_x = (window_size.x - msg.size.x) / 2
@onready var msg_position_y = window_size.y - ((window_size.y - msg.size.y) / 4)

@onready var label_position_x = (window_size.x - msg.size.x) / 2
@onready var label_position_y = window_size.y - ((window_size.y - msg.size.y) / 2.5)


func _ready():
	add_child(https_request)
	https_request.client_response.connect(__client_response)
	img.position = Vector2(img_position_x, img_position_y)
	msg.position = Vector2(msg_position_x, msg_position_y)
	label.position = Vector2(label_position_x, label_position_y)
	$Button.connect("pressed", _on_settings_button_pressed)


	print(Vector2(img_position_x, img_position_y))
	get_tree().get_root().set_transparent_background(true)


func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.is_action_pressed("ui_up"):
			get_tree().quit()
	
	if event is InputEventKey and event.is_pressed():
		var keycode = DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode)
		if OS.get_keycode_string(keycode) == "Enter":
			if msg.text != "":
				print(msg.text)
				post_handler(msg.text)
				msg.clear()
				label.text = ""


func __client_response(response: String):
	label.text = response

func post_handler(msg_: String):
	await https_request.post_msg(msg_)
	https_request.get_status(true)
	var status = await https_request.signal_status
	if status:
		https_request.get_status_msg()

func _on_settings_button_pressed():
	var config_scene = preload("res://Config.tscn").instantiate()
	config_scene.connect("config", _disableConfigBtn)
	add_child(config_scene)

func _disableConfigBtn(value: bool):
	$Button.disabled = value
