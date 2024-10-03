extends Area3D


@onready var enemy=get_parent().get_parent().get_parent().get_parent()
@export var damageFactor = 1
# Called when the node enters the scene tree for the first time.


func _on_area_body_entered(body):
	if body.is_in_group("bullet"):
		print("bullet hit")
		if body.avoid=='player':
			hit((body.mass*body.vel)/100)
		
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hit(force):
	print(force)
	enemy.health-=(force*damageFactor)/100

func alert():
	enemy.hearNoise()
