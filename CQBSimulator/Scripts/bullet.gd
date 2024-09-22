extends RigidBody3D

var avoid
var vel
var fired=false
# Called when the node enters the scene tree for the first time.
func _ready():
	top_level=true
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if fired:
		
		apply_impulse(-transform.basis.z*vel,transform.basis.z)


func _on_area_3d_body_entered(body):
	
	
	if !body.is_in_group(avoid):
		print("hit",body)
		queue_free()
