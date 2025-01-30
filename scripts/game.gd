#控制游戏脚本
extends Node2D

func _ready() -> void:
	#连接信号
	EventBus.crate_reached_dest.connect(_on_crate_reached_dest)
	
#当此信号emit时执行
func _on_crate_reached_dest():
	#遍历分组中所有crate，如果每个都is_reached，则print
	for crate: Crate in get_tree().get_nodes_in_group("crates"):
		if not crate.is_reached:
			return
	print("Level Complete!")
