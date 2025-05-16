extends Node

@onready var CloseBtn = $VBoxContainer/Button2
@onready var BordlessBtn = $VBoxContainer/Button
@onready var AlwaysOnTopBtn = $VBoxContainer/Button3
@onready var OpacityBtn = $VBoxContainer/Button4

signal config(change:bool)

func _ready():
    CloseBtn.connect("pressed", _quit)
    OpacityBtn.connect("pressed", _opacityChange)
    BordlessBtn.connect("pressed", _bordlessChange)
    AlwaysOnTopBtn.connect("pressed", _alwaysOnTop)
    emit_signal("config", true)

func _quit():
    emit_signal("config", false)
    queue_free()

func _opacityChange():
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, !DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT))

func _bordlessChange():
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, !DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS))

func _alwaysOnTop():
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, !DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP))
