extends RigidBody2D

enum Player_State {Idle, Dead}

const GRID_SIZE: int = 16

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var ray_cast_2d_down: RayCast2D = $RayCast2D_Down
@onready var ray_cast_2d_right: RayCast2D = $RayCast2D_Right
@onready var ray_cast_2d_up: RayCast2D = $RayCast2D_Up
@onready var ray_cast_2d_left: RayCast2D = $RayCast2D_Left

var player_state: Player_State = Player_State.Idle
var target_position = position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_ray_cast_2d()
	
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	position = position.bezier_interpolate(position, position + (target_position - position), target_position, 0.3)
	animation_control(player_state)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_move_up"):
		if not ray_cast_2d_up.is_colliding():
			print("Move Up")
			move(Vector2(0, -1))
		else:
			print("Blocked")
	elif event.is_action_pressed("player_move_down"):
		if not ray_cast_2d_down.is_colliding():
			print("Move Down")
			move(Vector2(0, 1))
		else:
			print("Blocked")
	elif event.is_action_pressed("player_move_left"):
		if not ray_cast_2d_left.is_colliding():
			print("Move Left")
			move(Vector2(-1, 0))
		else:
			print("Blocked")
	elif event.is_action_pressed("player_move_right"):
		if not ray_cast_2d_right.is_colliding():
			print("Move Right")
			move(Vector2(1, 0))
		else:
			print("Blocked")
		
func move(direction: Vector2):
	if(position.distance_to(target_position) <= 1):
		target_position += direction * GRID_SIZE

func animation_control(state: Player_State):
	match state:
		Player_State.Idle:
			animated_sprite_2d.play("Idle")
		Player_State.Dead:
			animated_sprite_2d.play("Die")
		_:
			animated_sprite_2d.play("Idle")

func initialize_ray_cast_2d():
	ray_cast_2d_down.add_exception(self)
	ray_cast_2d_right.add_exception(self)
	ray_cast_2d_up.add_exception(self)
	ray_cast_2d_left.add_exception(self)
	
	ray_cast_2d_down.collision_mask = 1 << 0
	ray_cast_2d_right.collision_mask = 1 << 0
	ray_cast_2d_up.collision_mask = 1 << 0
	ray_cast_2d_left.collision_mask = 1 << 0
