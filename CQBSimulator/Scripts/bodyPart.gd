extends Area3D


@onready var enemy=get_parent().get_parent().get_parent().get_parent()
@export var damageFactor = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hit(force):
	enemy.health-=force*damageFactor

func alert():
	enemy.hearNoise()
