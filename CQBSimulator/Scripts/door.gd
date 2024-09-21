extends Node3D

@onready var animPlayer=$door/AnimationPlayer

var open=false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


	
func place(posXZ,posY,rot):
	position.x=posXZ[0]
	position.y=posY
	position.z=posXZ[1]
	rotation.y=rot
	
func toggle():
	if open:
		animPlayer.play_backwards("open")
	else:
		animPlayer.play("open")
	open=!open
