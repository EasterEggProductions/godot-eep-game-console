extends Button

@export var sfx_pressed = "ui_confirm"
@export var sfx_focus = "ui_navigate"
@export var sfx_mouse_hover = "ui_navigate"


func _ready() -> void:
	connect("focus_entered", FAM.play_effect.bind(sfx_focus))
	connect("pressed", FAM.play_effect.bind(sfx_pressed))
	connect("mouse_entered", FAM.play_effect.bind(sfx_focus))