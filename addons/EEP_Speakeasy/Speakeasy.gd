extends Node
## Central Manager for Speakeasy node dialog system

var nodes : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	#make_test_data()
	#loadFromFile('EEP_GameTools/Speakeasy/debug_testing.speakeasy') # NOTE old format from BlOm
	loadFromFile('addons/EEP_Speakeasy/debug_testing.speakeasy')
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	pass


func parseAndExecuteSpeakeasyCode(codestring : String) -> void:
	var codes : PackedStringArray
	if "|" in codestring:
		codes = codestring.split("|")
	elif "(" in codestring:
		codes = codestring.split(" ")
	else:
		codes = [codestring]
	for cmd in codes:
		print(cmd)
		var resp : String = console.ExecuteCommand(cmd) 
		print(resp)

func loadFromFile(filepath : String) -> void:
	var file : FileAccess = FileAccess.open(filepath, FileAccess.READ)
	var fdat : String = file.get_as_text()
	var nodes_maybe : Variant = JSON.parse_string(fdat) # NOTE during 4.4.1 upgrade typing was unknown, so this was made Variant type
	#print(nodes_maybe)
	var new_nodes : Dictionary = {}
	for key : String in nodes_maybe.keys():
		var seN : SpeakeasyNode = SpeakeasyNode.new()
		seN.nodeName = key
		seN.nodeText = nodes_maybe[key].speech # TODO, change to nodeSay on other implimentation
		seN.executeCode = nodes_maybe[key].executeCode
		for resp : Dictionary in nodes_maybe[key].replies: # old version was replies. horrid mismatching >.<
			var seR : SpeakeasyResponse = SpeakeasyResponse.new()
			seR.responseSay = resp["responseSay"]
			seR.leadingNode = resp["leadingNode"]
			seR.executeCode = resp["executeCode"]
			seR.requirement = resp["requirement"]
			seN.responses.append(seR)
		new_nodes[key] = seN
	nodes = new_nodes

func make_test_data() -> void:
	var n1 : SpeakeasyNode = SpeakeasyNode.new()
	n1.nodeName = "node_01"
	n1.nodeText = "Welcome to speakeasy. The easiest of speaks"
	var n1r1 : SpeakeasyResponse = SpeakeasyResponse.new()
	n1r1.responseSay = "Thank you."
	n1r1.leadingNode = "node_02"
	n1r1.executeCode = "questToken add wasPoliteInConversation"
	n1r1.requirement = ""
	n1.responses.append(n1r1)
	var n1r2 : SpeakeasyResponse = SpeakeasyResponse.new()
	n1r2.responseSay = "Go fuck yourself, Kogami."
	n1r2.leadingNode = "node_03"
	n1r2.executeCode = "questToken add wasRudeInConversation"
	n1r2.requirement = ""
	n1.responses.append(n1r2)
	var n1r3 : SpeakeasyResponse = SpeakeasyResponse.new()
	n1r3.responseSay = "I have determined that you are a dumbo."
	n1r3.leadingNode = "node_04"
	n1r3.executeCode = ""
	n1r3.requirement = "questToken wasPoliteInConversation"
	n1.responses.append(n1r3)
	var questrand : SpeakeasyResponse  = SpeakeasyResponse.new()
	questrand.responseSay = "I heard you need a..."
	questrand.leadingNode = "rand_quest"
	questrand.executeCode = ""
	questrand.requirement = ""
	n1.responses.append(questrand)
	var goodbye : SpeakeasyResponse  = SpeakeasyResponse.new()
	goodbye.responseSay = "Goodbye! :D"
	goodbye.leadingNode = "GOODBYE"
	goodbye.executeCode = ""
	goodbye.requirement = ""
	n1.responses.append(goodbye)

	var n2 : SpeakeasyNode = SpeakeasyNode.new()
	n2.nodeName = "node_02"
	n2.nodeText = "Wow, you are so polite. So polite I wrote it in your quest Journal."
	var n2r1 : SpeakeasyResponse = SpeakeasyResponse.new()
	n2r1.responseSay = "Thank you."
	n2r1.leadingNode = "node_01"
	n2r1.executeCode = "questToken add wasPoliteInConversation"
	n2r1.requirement = ""
	n2.responses.append(n2r1)
	var n2r2 : SpeakeasyResponse = SpeakeasyResponse.new()
	n2r2.responseSay = "That's cool I guess"
	n2r2.leadingNode = "node_01"
	n2r2.executeCode = ""
	n2r2.requirement = ""
	n2.responses.append(n2r2)
	

	var n3 : SpeakeasyNode = SpeakeasyNode.new()
	n3.nodeName = "node_03"
	n3.nodeText = "You are quite rude! So rude I have told everyone and they disliked that."
	var n3r1 : SpeakeasyResponse = SpeakeasyResponse.new()
	n3r1.responseSay = "Excellent, my reputation will precede me!"
	n3r1.leadingNode = "node_01"
	n3r1.executeCode = "questToken add aRealAsshole"
	n3r1.requirement = ""
	n3.responses.append(n3r1)
	var n3r2 : SpeakeasyResponse = SpeakeasyResponse.new()
	n3r2.responseSay = "Goodness! I am so sorry?"
	n3r2.leadingNode = "node_02"
	n3r2.executeCode = "questToken remove wasRudeInConversation"
	n3r2.requirement = ""
	n3.responses.append(n3r2)
	

	var n4 : SpeakeasyNode = SpeakeasyNode.new()
	n4.nodeName = "node_04"
	n4.nodeText = "ASSERTION CORRECT, ACCESS GRANTED. [The vagina opens ominously]"
	var n4r1 : SpeakeasyResponse = SpeakeasyResponse.new()
	n4r1.responseSay = "Oh that is lovely."
	n4r1.leadingNode = "node_01"
	n4r1.executeCode = ""
	n4r1.requirement = ""
	n4.responses.append(n4r1)

	var q_ask : SpeakeasyNode = SpeakeasyNode.new()
	q_ask.nodeName = "rand_quest"
	q_ask.nodeText = "Yes! I do need someone to take on this quest. Are you sure!?"
	var qY : SpeakeasyResponse = SpeakeasyResponse.new()
	qY.responseSay = "I will do this for you."
	qY.leadingNode = "rand_quest.accept"
	qY.executeCode = "quest"
	qY.requirement = ""
	var qN : SpeakeasyResponse = SpeakeasyResponse.new()
	qN.responseSay = "I cannot do this."
	qN.leadingNode = "node_01"
	qN.executeCode = ""
	qN.requirement = ""
	q_ask.responses.append_array([qY, qN])

	var q_accept : SpeakeasyNode = SpeakeasyNode.new()
	q_accept.nodeName = "rand_quest.accept"
	q_accept.nodeText = "Oh thank you so much! I have put that in your copybook now."
	var resp : SpeakeasyResponse = SpeakeasyResponse.new()
	resp.responseSay = "You are very welcome."
	resp.leadingNode = "node_02"
	resp.executeCode = ""
	resp.requirement = ""
	q_accept.responses.append(resp)

	for n : SpeakeasyNode in [n1, n2, n3, n4, q_ask, q_accept]:
		nodes[n.nodeName] = n
	
