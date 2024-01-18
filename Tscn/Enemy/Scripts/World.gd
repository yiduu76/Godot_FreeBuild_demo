extends Node2D
@onready var path=""
@onready var wall=preload("res://Tscn/wall.tscn")
var last_Wall
#@onready var assemblys=preload("res://saves/save_assemblys.tscn")
func _ready():
	path=self.get_path()
	Glo.world_path=path
	spawn_wall()
#	读取并实例保存的场景，添加入场景树内
#	var temp=assemblys.instantiate()
#	self.add_child(temp)
#	temp.global_position=Vector2.ZERO
func spawn_wall():
	var temp_wall=wall.instantiate()
	self.add_child(temp_wall)
	temp_wall.global_translate(Glo.player_pos)
	if last_Wall!=null:
		last_Wall.queue_free()
	last_Wall=temp_wall
