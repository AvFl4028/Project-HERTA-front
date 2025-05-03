extends Node2D

@onready var https_request = Request.new("http://127.0.0.1:8000")
@onready var label = $Label
@onready var msg = $LineEdit

func _ready():
	add_child(https_request)
	https_request.client_response.connect(__client_response)
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

func post_handler(msg: String):
	await https_request.post_msg(msg)
	https_request.get_status(true)
	var status = await https_request.signal_status
	if status:
		https_request.get_status_msg()