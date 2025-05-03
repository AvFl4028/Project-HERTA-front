class_name Request
extends HTTPRequest

var url: String

signal finished(response: Dictionary)
signal signal_status(response: bool)
signal signal_post_status(response: bool)
signal client_response(response: String)


func _init(_url: String):
	url = _url

func _ready():
	request_completed.connect(_on_request_completed)

# Método público asincrónico
func fetch(custom_url: String, method: HTTPClient.Method, msg: String) -> Dictionary:
	var err: int

	if method == HTTPClient.METHOD_POST:
		err = request(custom_url, ["Content-Type: application/json"], method, msg)
	else:
		err = request(custom_url, [], method, msg)


	if err != OK:
		push_error("HTTP request failed to start")
		return {}
    
    # Esperar hasta que se emita la señal 'finished'	
	return await finished

func post_msg(msg: String):
	var post_url: String = url + "/post"
	var res = await fetch(post_url, HTTPClient.METHOD_POST, '{"message":"' + msg + '"}')
	emit_signal("signal_post_status", res["status"])

func get_status(repeat:bool = false):
	var getUrl: String = url + "/get"

	var res = await fetch(getUrl, HTTPClient.METHOD_GET, "")
	await get_tree().create_timer(1).timeout
	print(res)
	if (!res["ready"] and repeat):
		await get_status(true)
	emit_signal("signal_status", res["ready"])

func get_status_msg():
	var statusMsgUrl: String = url + "/assistant/response"
	var res = await fetch(statusMsgUrl, HTTPClient.METHOD_GET, "")
	emit_signal("client_response", res["message"])

func _on_request_completed(result, response_code, headers, body):
	var body_text = body.get_string_from_utf8()
	print("RESULT: ", result)
	print("RESPONSE CODE: ", response_code)
	print("HEADERS: ", headers)
	print("BODY: ", body_text)

	var json = JSON.parse_string(body_text)
	if json == null:
		print("Error al parsear JSON")
		json = {}
	
	emit_signal("finished", json)
