extends Node3D


var xExtents = 0
var zExtents = 0
var enemyData=[]

const enemy = preload("res://Nodes/Enemy.tscn")

func activate():
	print(enemyData)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
