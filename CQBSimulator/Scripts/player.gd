extends CharacterBody3D

var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.8
const SENSITIVITY = 0.004
const SLOW_WALK_SPEED = 1
const BOB_FREQ = 2.4
const BOB_AMP = 0.03
var t_bob = 0.0

const BASE_FOV = 90.0
const FOV_CHANGE = 0.5

var gravity = 15
var weaponData

var bulletCount=[0,0]
var pistolADSPos=Vector3(0,-0.038,-0.197)
var rifleADSPos=Vector3(0,-0.095,-0.197)
var gunADSPos=rifleADSPos
var adsSpeed=30

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var interactRay=$Head/Camera3D/interactionRay
@onready var gun=$Head/Camera3D/Rifle
@onready var noiseLevel=$noiseLevel
@onready var gunHipPos=Vector3(0.562,-0.313,-0.554)

var breathNoise=2
var walkNoise=10
var slowWalkNoise=1
var runNoise=25
var shootNoise=100
var speedSound=50
var doorOpenNoise=25

func _ready():
	gun.parentName="player"
	gun.position=gunHipPos
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(60))

func initialWeaponSetup(bCount):
	gun.initialize(weaponData["Weapon1"],0,bCount)

func _physics_process(delta):
	noiseLevel.scale=noiseLevel.scale.lerp(Vector3(breathNoise,breathNoise,breathNoise),delta*speedSound)
	if Input.is_action_just_pressed('r'):
		gun.reload()
	
	if Input.is_action_pressed("rightClick"):
		gun.position=gun.position.lerp(gunADSPos,delta*adsSpeed)
		
	else:
		gun.position=gun.position.lerp(gunHipPos,delta*adsSpeed)
	
	if Input.is_action_just_pressed("1"):
		
		if weaponData["Weapon1"]["ModelOptions"]=="Pistol":
			gunADSPos=pistolADSPos
		else:
			gunADSPos=rifleADSPos
		gun.initialize(weaponData["Weapon1"],0)
		
		
	if Input.is_action_just_pressed("2"):
		
		if weaponData["Weapon2"]["ModelOptions"]=="Pistol":
			gunADSPos=pistolADSPos
		else:
			gunADSPos=rifleADSPos
			
		gun.initialize(weaponData["Weapon2"],1)
		
	
	if Input.is_action_just_pressed('leftClick'):
		noiseLevel.scale=noiseLevel.scale.lerp(Vector3(shootNoise,shootNoise,shootNoise),delta*speedSound)
		gun.triggerDown=true
	if Input.is_action_just_released('leftClick'):
		gun.triggerDown=false
		
		
		
	
	if Input.is_action_just_pressed("e") and interactRay.is_colliding():
		var obj=interactRay.get_collider()
		
		if obj.is_in_group("door"):
			noiseLevel.scale=noiseLevel.scale.lerp(Vector3(doorOpenNoise,doorOpenNoise,doorOpenNoise),delta*speedSound)	
			obj.get_parent().toggle()
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	

	var input_dir = Input.get_vector("a", "d", "w", "s")
	var direction = (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if Input.is_action_pressed("leftshift"):
		
		speed = SPRINT_SPEED
	elif Input.is_action_pressed("ctrl"):
		speed = SLOW_WALK_SPEED
	else:
		speed = WALK_SPEED
	if is_on_floor():
		if direction:
			if speed == SPRINT_SPEED:
				noiseLevel.scale=noiseLevel.scale.lerp(Vector3(runNoise,runNoise,runNoise),delta*speedSound)
			elif speed==SLOW_WALK_SPEED:
				noiseLevel.scale=noiseLevel.scale.lerp(Vector3(slowWalkNoise,slowWalkNoise,slowWalkNoise),delta*speedSound)
			else:
				noiseLevel.scale=noiseLevel.scale.lerp(Vector3(walkNoise,walkNoise,walkNoise),delta*speedSound)
				
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	#else: #no movement mid-airwa obviously
		#velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		#velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos


func _on_noise_level_area_entered(area):
	if area.is_in_group("enemy"):
		
		area.alert()
