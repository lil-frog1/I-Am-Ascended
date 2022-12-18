extends KinematicBody2D

const UP_DIRECTION = Vector2.UP

export var speed = 300.0
export var jump_strength = 700.0
export var maximum_jumps = 2
export var double_jump_strength = 700.0
export var gravity = 1500.0
export var terminal_velocity = 600.0

var _jumps_made = 0
var _velocity = Vector2.ZERO

var world = get_parent()

func _process(delta):

	if Input.is_action_pressed("move_left") and $animatedBrick.scale.x > 0:
		$animatedBrick.scale.x = $animatedBrick.scale.x * -1

	if Input.is_action_pressed("move_right") and $animatedBrick.scale.x < 0:
		$animatedBrick.scale.x = $animatedBrick.scale.x * -1

	var _horizontal_direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	_velocity.x = _horizontal_direction * speed
	if _velocity.y < terminal_velocity:
		_velocity.y += gravity * delta

	var is_falling = _velocity.y > 0.0 and is_on_floor() == false
	var is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
	var is_double_jumping = Input.is_action_just_pressed("jump")
	var is_jump_canceled = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var is_idling = is_on_floor() and not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right")
	var is_running = is_on_floor() and not is_zero_approx(_velocity.x)


	if is_on_floor():
		_jumps_made = 0
	
	if is_idling:
		$animatedBrick.get_node("AnimationPlayer").play("idle")

	if is_running:
		$animatedBrick.get_node("AnimationPlayer").play("run")
	
	if is_falling:
		if _jumps_made < 1:
			_jumps_made = 1

	if is_jumping:
		$animatedBrick.get_node("AnimationPlayer").play("jump")
		_jumps_made += 1
		_velocity.y -= jump_strength
	
	elif is_double_jumping:
		_jumps_made += 1
		if _jumps_made <= maximum_jumps:
			if is_falling:
				_velocity.y = -double_jump_strength
			else:
				_velocity.y -= double_jump_strength
	_velocity = move_and_slide(_velocity, UP_DIRECTION)
