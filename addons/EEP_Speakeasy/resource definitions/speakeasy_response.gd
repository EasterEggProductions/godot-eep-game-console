extends Resource
class_name SpeakeasyResponse

## The response as displayed to the player
var responseSay : String = ""
## The node that this response will lead to
var leadingNode : String = ""
## Console or other commands, as strings seperated by the pipe |
var executeCode : String = ""
## Console or other commands, currently all must evaluate to true, 
## implicit ands, and then this response will be displayed to the player
var requirement : String = ""