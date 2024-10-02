extends Node3D


@onready var gun = $Gun
@onready var animationPlayer = $AnimationPlayer
# Called when the node enters the scene tree for the first time.

#rotate gun by 8 degrees down if crouching
var health = 100

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
