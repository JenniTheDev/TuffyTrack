extends KinematicBody

var camera_angle = 0
var mouse_sensitivity = 0.3

var velocity = Vector3()
var direction = Vector3()

# fly variables
const FLY_SPEED = 40
const FLY_ACCEL = 4

# walk variables
var gravity = -9.8 * 3
const MAX_SPEED = 20
const MAX_RUNNING_SPEED = 30
const ACCEL =2 
const DEACCEL = 6

# jumping
var jump_height = 15




# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	walk(delta)


func _input(event):
	if event is InputEventMouseMotion:
		$Head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		
		var change = -event.relative.y * mouse_sensitivity
		if change + camera_angle < 90 and change + camera_angle >= -90:
			$Head/Camera.rotate_x(deg2rad(change))
			camera_angle += change

func walk(delta):
	direction = Vector3()
	
	# get the rotation of the camera
	var aim = $Head/Camera.get_global_transform().basis
	
	# check input and change direction
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.z
	if Input.is_action_pressed("move_right"):
		direction += aim.z	
		
	# I dont know why this direction doesn't work, commented it out	
	#direction = direction.nomralized()
	
	velocity.y += gravity * delta
	
	var temp_velocity = velocity
	temp_velocity.y = 0
	
	var speed
	if Input.is_action_pressed("move_sprint"):
		speed = MAX_RUNNING_SPEED
	else:
		speed = MAX_SPEED
	
	# where would the player go at max speed
	var target = direction * speed
	
	var accelteration
	if direction.dot(temp_velocity) > 0:
		accelteration = ACCEL
	else:
		accelteration = DEACCEL
	
	# calculate a portion of the distance to go
	temp_velocity = velocity.linear_interpolate(target, accelteration * delta)
	
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	# move
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_height



func fly(delta):
	direction = Vector3()
	
	# get the rotation of the camera
	var aim = $Head/Camera.get_global_transform().basis
	
	# check input and change direction
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.z
	if Input.is_action_pressed("move_right"):
		direction += aim.z	
		
	#direction = direction.nomralized()
	
	# where would the player go at max speed
	var target = direction * FLY_SPEED
	
	# calculate a portion of the distance to go
	velocity = velocity.linear_interpolate(target, FLY_ACCEL * delta)
	
	# move
	move_and_slide(velocity)

func _on_Enemy_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Assets/Main_Project_Scenes/GameOver.tscn") 
