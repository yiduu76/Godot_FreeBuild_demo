extends Node2D
@onready var tile_Wall=$wall
@onready var tile_background=$background
@onready var tile_plant_8=$plant_8x8
@onready var tile_plant_32=$plant_32x32
@onready var left_wall_x=-30
@onready var right_wall_x=170
func _ready():
	randomize()
	set_main_scene_color()
	set_background()
	set_plants()
	tile_Wall.set_cells_terrain_connect(0,tile_Wall.get_used_cells(0),0,0,false)

func tile_is_empty(tile,pos):
	if tile.get_cell_alternative_tile(0,pos,true)==-1:
		return true
	else :
		return false

func set_plants():
	var play_32_pos=Vector2(int(Glo.player_pos.x/32),int(Glo.player_pos.y/32))
	for i in 24:
		for j in 12:
			var set_num=randf_range(0,100)
			var pos_1=Vector2(i+play_32_pos.x,j+play_32_pos.y)
			var pos_2=Vector2(-i+play_32_pos.x,j+play_32_pos.y)
			var pos_3=Vector2(i+play_32_pos.x,-j+play_32_pos.y)
			var pos_4=Vector2(-i+play_32_pos.x,-j+play_32_pos.y)
			if set_num<14:
				var rand_x=randi_range(0,9)
				var rand_y=randi_range(0,9)
				if tile_is_empty(tile_plant_8,pos_1):
					tile_plant_8.set_cell(0,pos_1,0,Vector2(rand_x,rand_y),0)
				if tile_is_empty(tile_plant_8,pos_2):
					tile_plant_8.set_cell(0,pos_2,0,Vector2(rand_x,rand_y),0)
				if tile_is_empty(tile_plant_8,pos_3):
					tile_plant_8.set_cell(0,pos_3,0,Vector2(rand_x,rand_y),0)
				if tile_is_empty(tile_plant_8,pos_4):
					tile_plant_8.set_cell(0,pos_4,0,Vector2(rand_x,rand_y),0)
			else :
				if tile_is_empty(tile_plant_8,pos_1):
					tile_plant_8.set_cell(0,pos_1,0,Vector2(9,0),0)
				if tile_is_empty(tile_plant_8,pos_2):
					tile_plant_8.set_cell(0,pos_2,0,Vector2(9,0),0)
				if tile_is_empty(tile_plant_8,pos_3):
					tile_plant_8.set_cell(0,pos_3,0,Vector2(9,0),0)
				if tile_is_empty(tile_plant_8,pos_4):
					tile_plant_8.set_cell(0,pos_4,0,Vector2(9,0),0)

func set_background():
	var play_32_pos=Vector2(int(Glo.player_pos.x/32),int(Glo.player_pos.y/32))
	for i in 24:
		for j in 12:
			var pos_1=Vector2(i+play_32_pos.x,j+play_32_pos.y)
			var pos_2=Vector2(-i+play_32_pos.x,j+play_32_pos.y)
			var pos_3=Vector2(i+play_32_pos.x,-j+play_32_pos.y)
			var pos_4=Vector2(-i+play_32_pos.x,-j+play_32_pos.y)
			if tile_is_empty(tile_background,pos_1):
				tile_background.set_cell(0,pos_1,0,Vector2(2,0),0)
			if tile_is_empty(tile_background,pos_2):
				tile_background.set_cell(0,pos_2,0,Vector2(2,0),0)
			if tile_is_empty(tile_background,pos_3):
				tile_background.set_cell(0,pos_3,0,Vector2(2,0),0)
			if tile_is_empty(tile_background,pos_4):
				tile_background.set_cell(0,pos_4,0,Vector2(2,0),0)

func set_main_scene_color():
	pass
#	var adjust_color_h=Glo.main_scene_color.x
#	if adjust_color_h>1:
#		adjust_color_h-=1
#	tile_background.modulate.h=adjust_color_h
#	tile_background.modulate.s=0.1
	tile_background.modulate.v=0.4

func _on_timer_timeout():
	$Timer.start(0)
	set_background()
	set_plants()
