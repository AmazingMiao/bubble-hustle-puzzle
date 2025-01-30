extends Node2D

# 补间动画对象
var tween: Tween

# 通过获取父节点的方式获取所在TileMapLayer
@onready var map: TileMapLayer = get_parent()
# 获取在map上的网格坐标
@onready var cell_position: Vector2i = map.local_to_map(position)

# 移动函数，通过传进网格坐标，获取实际坐标，然后传送
func move_to(cell: Vector2i):
	cell_position = cell
	#position = map.map_to_local(cell_position)
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", map.map_to_local(cell_position), 0.2)

#撞墙动画	
func bump(cell: Vector2i):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", (map.map_to_local(cell) + position)/2, 0.1)
	tween.tween_property(self, "position", position, 0.1)

#获取目标tile是否是wall
func is_wall(cell: Vector2i) -> bool:
	var data := map.get_cell_tile_data(cell)
	if not data:
		return false
	return data.get_custom_data("is_wall")

#获取目标tile是否是dest
func is_dest(cell: Vector2i) -> bool:
	var data := map.get_cell_tile_data(cell)
	if not data:
		return false
	return data.get_custom_data("is_dest")

#获取目标tile上的crate
func get_crate(cell: Vector2i) -> Crate:
	#在crates场景分组中搜索
	for crate: Crate in get_tree().get_nodes_in_group("crates"):
		if crate.cell_position == cell:
			return crate
	#都不是crate的话返回null
	return null
