class_name Crate
extends "res://scripts/game_object.gd"

var is_reached := false:
	#当变量改变时
	set(v):
		#如果变量没有变化，则不执行后续逻辑
		if is_reached == v:
			return
		is_reached = v
		#播放动画，发出全局信号
		animation_player.play("reached" if is_reached else "default")
		EventBus.crate_reached_dest.emit()
		
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func move_to(cell: Vector2i):
	super(cell)
	is_reached = is_dest(cell)
