extends Node
@onready var main_scene_color=Vector4.ZERO
@onready var input_vec=Vector2.ZERO
@onready var player_pos=Vector2.ZERO
@onready var sun_pos=Vector2.ZERO
@onready var build_mode=true
@onready var world_path=" "
@onready var pick_node=null
@onready var hover_node=null
@onready var input_ro=0.0
@onready var input_ro_need_tick=120.0
@onready var rest_state=true
@onready var wave_num=0
@onready var world_scene_type:int=101
@onready var bullet_material_type:int=101

@onready var spawn_need_tick=60
@onready var spawn_tick=0
var player
var lock_target
signal Ey_spawn_forword(material_type)
signal signal_col_off
signal signal_col_on
signal signal_rotate_mob(degrees)
signal signal_rotate_main(degrees)

func _ready():
	self.process_mode=Node.PROCESS_MODE_ALWAYS
	get_main_scene_color()
func get_main_scene_color():
	pass
#	var icon=match_material_type(world_scene_type)
#	var temp=icon.texture.get_image()
#	icon.modulate=temp.get_pixel(8,8)
#	main_scene_color.x=icon.modulate.h

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		pick_node=null
	input_vec.x=Input.get_axis("ui_left","ui_right")
	input_vec.y=Input.get_axis("ui_up","ui_down")
	rotate_control()
	build_control()

func rotate_control():
	if pick_node!=null:
		pick_node.global_position=pick_node.get_global_mouse_position()
		if Input.is_action_just_pressed("ui_rotate_R"):
			emit_signal("signal_rotate_mob",90)
		elif Input.is_action_just_pressed("ui_rotate_L"):
			emit_signal("signal_rotate_mob",-90)
	elif pick_node==null&&build_mode==false:
		if Input.is_action_just_pressed("ui_rotate_R"):
			emit_signal("signal_rotate_main",90)
			col_trans()
		elif Input.is_action_just_pressed("ui_rotate_L"):
			emit_signal("signal_rotate_main",-90)
			col_trans()

func build_control():
	if Input.is_action_just_pressed("ui_gravity"):
		build_mode=!build_mode
		if build_mode==false:
			pick_node=null
			col_trans()
	if Glo.build_mode:
		Engine.time_scale=0.1
	else :
		Engine.time_scale=1

func col_trans():
	col_off()
	await get_tree().create_timer(1.0).timeout
	col_on()

func col_off():
	emit_signal("signal_col_off")

func col_on():
	emit_signal("signal_col_on")

func match_material_type(type):
	var icon=Sprite2D.new()
	match [type]:
		[101]:
			icon.texture=load("res://PNG/Mobs/Woods/N_all.png")
		[102]:
			icon.texture=load("res://PNG/Mobs/Woods/R_all.png")
		[103]:
			icon.texture=load("res://PNG/Mobs/Woods/SR_all.png")
		[104]:
			icon.texture=load("res://PNG/Mobs/Woods/SSR_all.png")
		[201]:
			icon.texture=load("res://PNG/Mobs/Irons/Tough_iron/N_all.png")
		[202]:
			icon.texture=load("res://PNG/Mobs/Irons/Tough_iron/R_all.png")
		[203]:
			icon.texture=load("res://PNG/Mobs/Irons/Tough_iron/SR_all.png")
		[204]:
			icon.texture=load("res://PNG/Mobs/Irons/Tough_iron/SSR_all.png")
		[301]:
			icon.texture=load("res://PNG/Mobs/Irons/Soft_iron/N_all.png")
		[302]:
			icon.texture=load("res://PNG/Mobs/Irons/Soft_iron/R_all.png")
		[303]:
			icon.texture=load("res://PNG/Mobs/Irons/Soft_iron/SR_all.png")
		[304]:
			icon.texture=load("res://PNG/Mobs/Irons/Soft_iron/SSR_all.png")
		[101]:
			icon.texture=load("res://PNG/Enemys/Wood/N_all.png")
		[102]:
			icon.texture=load("res://PNG/Enemys/Wood/R_all.png")
		[103]:
			icon.texture=load("res://PNG/Enemys/Wood/SR_all.png")
		[104]:
			icon.texture=load("res://PNG/Enemys/Wood/SSR_all.png")
		[201]:
			icon.texture=load("res://PNG/Enemys/Iron/Tough_iron/N_all.png")
		[202]:
			icon.texture=load("res://PNG/Enemys/Iron/Tough_iron/R_all.png")
		[203]:
			icon.texture=load("res://PNG/Enemys/Iron/Tough_iron/SR_all.png")
		[204]:
			icon.texture=load("res://PNG/Enemys/Iron/Tough_iron/SSR_all.png")
		[301]:
			icon.texture=load("res://PNG/Enemys/Iron/Soft_iron/N_all.png")
		[302]:
			icon.texture=load("res://PNG/Enemys/Iron/Soft_iron/R_all.png")
		[303]:
			icon.texture=load("res://PNG/Enemys/Iron/Soft_iron/SR_all.png")
		[304]:
			icon.texture=load("res://PNG/Enemys/Iron/Soft_iron/SSR_all.png")
		_:pass
	return icon

