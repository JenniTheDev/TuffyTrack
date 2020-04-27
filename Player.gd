extends KinematicBody


var speed = 200
var direction = Vector3()
var gravity = -9.9
var velocity = Vector3()



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	direction = Vector3(0,0,0)
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1 
	if Input.is_action_pressed("ui_right"):
		direction.x += 1 	
	if Input.is_action_pressed("ui_up"):
		direction.z -= 1 
	if Input.is_action_pressed("ui_down"):
		direction.z += 1 
	direction = direction.normalized()
	
	move_and_slide(direction, Vector3(0,1,0))
	direction = direction * speed * delta
	velocity.y += gravity * delta
	velocity.x = direction.x
	velocity.z = direction.z
	
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	if is_on_floor() and Input.is_key_pressed(KEY_SPACE):
		velocity.y = 10
