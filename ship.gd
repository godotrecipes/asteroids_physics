extends RigidBody2D

@export var engine_power = 800
@export var spin_power = 10000

var thrust = Vector2.ZERO
var rotation_dir = 0
var teleport_pos = null

@onready var screensize = get_viewport_rect().size

func _ready():
	for i in 100:
		print(i)
		
func get_input():
	if Input.is_action_just_pressed("warp"):
		teleport_pos = Vector2(randf_range(0, screensize.x), randf_range(0, screensize.y))
		print("warping ", teleport_pos)
	thrust = Vector2.ZERO
	if Input.is_action_pressed("thrust"):
		thrust = transform.x * engine_power
	rotation_dir = Input.get_axis("rotate_left", "rotate_right")
		
func _physics_process(_delta):
	get_input()
	constant_force = thrust
	constant_torque = rotation_dir * spin_power

func _integrate_forces(state):
	if teleport_pos:
		state.transform.origin = teleport_pos
		teleport_pos = null
	var xform = state.transform
	xform.origin.x = wrapf(xform.origin.x, 0, screensize.x)
	xform.origin.y = wrapf(xform.origin.y, 0, screensize.y)
	state.transform = xform
