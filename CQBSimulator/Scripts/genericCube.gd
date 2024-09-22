extends StaticBody3D

@onready var mesh=$MeshInstance3D
@onready var collider=$CollisionShape3D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func place(posXZ,posY,scaleXZ,scaleY):
	
	
	var box = BoxShape3D.new()
	box.extents.x = scaleXZ[0]/2
	box.extents.y = scaleY/2
	box.extents.z = scaleXZ[1]/2
	
	position.x=posXZ[0]+scaleXZ[0]/2
	position.y=posY+scaleY/2
	position.z=posXZ[1]+scaleXZ[1]/2
	
	mesh.scale.x=scaleXZ[0]
	mesh.scale.y=scaleY
	mesh.scale.z=scaleXZ[1]
	
	collider.shape=box
	
	
	
	
	
	
	
