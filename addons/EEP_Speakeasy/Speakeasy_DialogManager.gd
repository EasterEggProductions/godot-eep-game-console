extends Panel

@export var deb_se : Node
@onready var speech_out : RichTextLabel = $speech 
@onready var responses : VBoxContainer = $responses
@export var scroll_delay : float = 0.01

@export var playerSocket : Node


signal conversation_started
signal conversation_ended
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	#go_to_node("node_01")
	modulate = Color.TRANSPARENT
	conversation_start("default")

func conversation_start(node : String) -> void:
	go_to_node(node)
	visible = true
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	emit_signal("conversation_started")
	## HACK 
#	playerSocket.input_lock = true

func conversation_end() -> void:
	visible = false
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.1)
	emit_signal("conversation_ended")
	## HACK 
#	playerSocket.input_lock = false

func go_to_node(nodeName : String) -> void: 
	if nodeName not in deb_se.nodes.keys(): # GOODBYE
		conversation_end()
		return
	var n : SpeakeasyNode = deb_se.nodes[nodeName]
	## Check for autoforward
	if "AUTOFORWARD" in n.executeCode:
		var codeEx : String = n.executeCode.substr(11)
		print(codeEx)
		for re : SpeakeasyResponse in n.responses:
			print("Evaluating " + re.leadingNode)
			if requirements_check(re.requirement):
				print("Going to " + re.leadingNode)
				deb_se.parseAndExecuteSpeakeasyCode(re.executeCode)
				go_to_node(re.leadingNode)
				return
		return
	print("Code: " + n.executeCode)
	deb_se.parseAndExecuteSpeakeasyCode(n.executeCode)
	speech_out.text = n.nodeText
	speech_out.visible_characters = 0
	var t : Tween = get_tree().create_tween()
	t.tween_property(speech_out, 'visible_characters', len(n.nodeText), (scroll_delay * len(n.nodeText)))

	clear_responses()
	for response in n.responses:
		print(response.responseSay)
		if requirements_check(response.requirement):
			var n_butt : Button = Button.new()
			n_butt.text = response.responseSay
			responses.add_child(n_butt)
			n_butt.pressed.connect(self._on_response_chosen.bind(response))

func requirements_check(reqs : String) -> bool:
	if len(reqs) == 0:
		return true
	var requirements : PackedStringArray = [reqs]
	if "|" in reqs:
		requirements = reqs.split("|")
	elif "(" in reqs:
		requirements = reqs.split(" ")
		print(len(requirements))
	for requirement in requirements:
		print("ping")
		var req : String = requirement
		if len(requirement) > 0 and requirement[0] == "!":
			req = requirement.substr(1)
		var resp : String = console.get_node("EEP_GameConsole").ExecuteCommand(req) 
		if resp == "False":
			print(requirement +" false")
			if requirement[0] == "!":
				print("NOT")
				continue
			return false
		else: 
			print(requirement + " true")
			print(len(requirement))
			if requirement[0] == "!":
				print("NOT")
				return false
		print(requirement + " true")
	return true

func clear_responses() -> void:
	for unruly_child in responses.get_children():
		unruly_child.queue_free()

func _on_response_chosen(resp : SpeakeasyResponse) -> void:
	deb_se.parseAndExecuteSpeakeasyCode(resp.executeCode)
	go_to_node(resp.leadingNode)
