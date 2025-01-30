extends "res://scripts/game_object.gd"


func _process(_delta: float) -> void:
	#检测有动画播放时return
	if tween and tween.is_running():
		return
	
	#获取玩家输入
	var dir := Vector2i(Input.get_vector("move_left", "move_right", "move_up", "move_down").round())
	
	#玩家无输入return
	if dir == Vector2i.ZERO:
		return
	
	#x轴有输入时将y轴归零，避免斜向移动
	if dir.x != 0:
		dir.y = 0
		
	#调用移动函数
	var dest := cell_position + dir
	
	#判断目的地是否为wall
	if is_wall(dest):
		#播放撞墙动画
		bump(dest)
		return
	
	#获取目的地上crate
	var crate := get_crate(dest)
	#如果目的地上有crate
	if crate:
		#得到crate目的地网格坐标
		var crate_dest := dest + dir
		#如果此crate目的地上是wall或者crate，则撞墙
		if is_wall(crate_dest) or get_crate(crate_dest):
			bump(dest)
			return
		#一系列判断后，移动此crate
		crate.move_to(crate_dest)
	
	#经过一系列判断后移动
	move_to(dest)
