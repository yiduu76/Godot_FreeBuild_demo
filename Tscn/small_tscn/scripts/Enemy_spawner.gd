extends Marker2D
class_name Enemy_spawner
@export var is_random=true
@export var material_type:int=101
@export var spawn_num=2

@onready var enemy_point=100.0
@onready var Elite_level:int=0

@export var Ey_16_1:PackedScene=null
@export var Ey_16_2:PackedScene=null
@export var Ey_16_3:PackedScene=null
@export var Ey_16_4:PackedScene=null
@export var Ey_8_1:PackedScene=null
@export var Ey_8_2:PackedScene=null
@export var Ey_8_3:PackedScene=null
@export var Ey_8_4:PackedScene=null
@export var Ey_8_add_1:PackedScene=null
@export var Ey_8_add_2:PackedScene=null
@export var Ey_8_add_3:PackedScene=null
@export var Ey_8_add_4:PackedScene=null
@export var Ey_8_add_5:PackedScene=null
@export var Ey_8_add_6:PackedScene=null
@export var Ey_8_add_7:PackedScene=null
@export var Ey_8_add_8:PackedScene=null
func _ready():
	pass

func _process(_delta):
	$notice.rotation_degrees+=0.7
	if spawn_num<0:
		self.queue_free()

func _on_timer_timeout():
	var rand_num=randf_range(0,999)
	var race_type=1
	const max_rand_num=999

	var type_1_loop_need_num=60
	var type_2_loop_need_num=120
	var type_3_loop_need_num=240

	var type_1_probability=0.7
	var type_2_probability=0.9
	var type_3_probability=0.98

	var type_1_offset_point=(enemy_point/type_1_loop_need_num)*0.01
	type_1_offset_point=clampf(type_1_offset_point,0.4,1.0)
	var type_2_offset_point=(enemy_point/type_2_loop_need_num)*0.01
	type_2_offset_point=clampf(type_2_offset_point,0.7,1.0)
	var type_3_offset_point=(enemy_point/type_3_loop_need_num)*0.01
	type_3_offset_point=clampf(type_3_offset_point,0.9,1.0)
	if rand_num<max_rand_num*type_1_probability:
		race_type=1
	elif rand_num<max_rand_num*type_2_probability:
		race_type=2
	elif rand_num<max_rand_num*type_3_probability:
		race_type=3
	else:
		race_type=4
	var temp_enemy=rand_enemy(race_type)
	if spawn_num>0:
		spawn(temp_enemy)
	spawn_num-=1

func spawn(temp_enemy):
	temp_enemy.material_type=material_type
	temp_enemy.is_random=is_random
	self.get_parent().add_child(temp_enemy)
	temp_enemy.material_type=material_type
	temp_enemy.translate(self.global_position)
	$Timer.start(0)

func rand_enemy(race_type):
	var rand_num=randf_range(0,999)
	const max_rand_num=999
	var temp=null
	match [race_type]:
		[1]:
			if rand_num<max_rand_num*0.7:
				temp=Ey_8_1.instantiate()
			elif rand_num<max_rand_num*0.9:
				temp=Ey_8_2.instantiate()
			elif rand_num<max_rand_num*0.98:
				temp=Ey_8_3.instantiate()
			else:
				temp=Ey_8_4.instantiate()
		[2]:
			if rand_num<max_rand_num*0.2:
				temp=Ey_8_add_1.instantiate()
			elif rand_num<max_rand_num*0.4:
				temp=Ey_8_add_2.instantiate()
			elif rand_num<max_rand_num*0.6:
				temp=Ey_8_add_3.instantiate()
			elif rand_num<max_rand_num*0.8:
				temp=Ey_8_add_4.instantiate()
			else:
				temp=Ey_8_add_5.instantiate()
		[3]:
			if rand_num<max_rand_num*0.7:
				temp=Ey_16_1.instantiate()
			elif rand_num<max_rand_num*0.9:
				temp=Ey_16_2.instantiate()
			elif rand_num<max_rand_num*0.98:
				temp=Ey_16_3.instantiate()
			else:
				temp=Ey_16_4.instantiate()
		[4]:
			if rand_num<max_rand_num*0.2:
				temp=Ey_8_add_1.instantiate()
			elif rand_num<max_rand_num*0.4:
				temp=Ey_8_add_2.instantiate()
			elif rand_num<max_rand_num*0.6:
				temp=Ey_8_add_3.instantiate()
			elif rand_num<max_rand_num*0.8:
				temp=Ey_8_add_4.instantiate()
			else:
				temp=Ey_8_add_5.instantiate()
	return temp
