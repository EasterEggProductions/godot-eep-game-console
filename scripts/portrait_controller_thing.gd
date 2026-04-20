extends Node

@export var portraits : Array[Texture2D]
@export var portrait_area : TextureRect

var cur_por = 0


func _inc_portrait(move : int):
	cur_por = (cur_por + move) % len(portraits)
	portrait_area.texture = portraits[cur_por]