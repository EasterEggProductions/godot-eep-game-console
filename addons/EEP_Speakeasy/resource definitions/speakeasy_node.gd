extends Resource
class_name SpeakeasyNode

## Title, but hopefully in a descriptive way. like core_JetMcCoal_insertion or something, idk
var nodeName : String = ""

## Text displayed to player. Could support bbcode, idk.
var nodeText : String = ""

var executeCode : String = ""

# The responses 
var responses : Array[SpeakeasyResponse]