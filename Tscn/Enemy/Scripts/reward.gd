extends Control
@onready var mob_0=preload("res://Tscn/Mob_tscn/mob_Nor_box.tscn")
@onready var mob_1=preload("res://Tscn/Mob_tscn/mob_Nor_battery.tscn")
@onready var mob_2=preload("res://Tscn/Mob_tscn/mob_Nor_drill.tscn")
@onready var mob_3=preload("res://Tscn/Mob_tscn/mob_Nor_ejector.tscn")
@onready var mob_4=preload("res://Tscn/Mob_tscn/mob_Nor_freegun.tscn")
@onready var mob_5=preload("res://Tscn/Mob_tscn/mob_Nor_gun.tscn")
@onready var mob_6=preload("res://Tscn/Mob_tscn/mob_Nor_triangel.tscn")
@onready var mob_7=preload("res://Tscn/Mob_tscn/mob_Am_divide.tscn")
@onready var mob_8=preload("res://Tscn/Mob_tscn/mob_Am_tri.tscn")
@onready var mob_9=preload("res://Tscn/Mob_tscn/mob_De_deflect.tscn")
@onready var mob_10=preload("res://Tscn/Mob_tscn/mob_De_slow.tscn")
@onready var mob_11=preload("res://Tscn/Mob_tscn/mob_S_cd.tscn")
@onready var mob_12=preload("res://Tscn/Mob_tscn/mob_S_num.tscn")
@onready var mob_13=preload("res://Tscn/Mob_tscn/mob_S_speed.tscn")
@onready var mob_14=preload("res://Tscn/Mob_tscn/mob_Am_trace.tscn")
#如何解决化为蛇型

@onready var buy_mob_pos=Vector2(-2000,0)
@onready var Tip_label=$Tip
@onready var mob_button_Container=$mobs/GridContainer
@onready var materail_type:int=101
var un_init_mobs
var mobs
var mob_buttons
func _ready():
	Tip_label.visible=false
	mobs=[mob_0,mob_1,mob_2,mob_3,mob_4,mob_5,mob_6,mob_7,mob_8,mob_9,mob_10,mob_11,mob_12,mob_13,mob_14]
	un_init_mobs=[mob_0,mob_1,mob_2,mob_3,mob_4,mob_5,mob_6,mob_7,mob_8,mob_9,mob_10,mob_11,mob_12,mob_13,mob_14]
	mobs_init()
	button_texture_change()
func button_texture_change():
	var j=0
	for i in mob_button_Container.get_children():
		var temp_icon=i.get_node("Sprite2D")
		temp_icon.texture=mobs[j].icon.texture
		temp_icon.region_rect=mobs[j].icon.region_rect
		temp_icon.material.set_shader_parameter("palette_out",load(color_path(materail_type)))
		j+=1

func color_path(type):
	match [type]:
		[101]:
			return ("res://PNG/Mobs/Colors/Wood/N.png")
		[102]:
			return ("res://PNG/Mobs/Colors/Wood/R.png")
		[103]:
			return ("res://PNG/Mobs/Colors/Wood/SR.png")
		[104]:
			return ("res://PNG/Mobs/Colors/Wood/SSR.png")
		[201]:
			return ("res://PNG/Mobs/Colors/Iron_T/N.png")
		[202]:
			return ("res://PNG/Mobs/Colors/Iron_T/R.png")
		[203]:
			return ("res://PNG/Mobs/Colors/Iron_T/SR.png")
		[204]:
			return ("res://PNG/Mobs/Colors/Iron_T/SSR.png")
		[301]:
			return ("res://PNG/Mobs/Colors/Iron_S/N.png")
		[302]:
			return ("res://PNG/Mobs/Colors/Iron_S/R.png")
		[303]:
			return ("res://PNG/Mobs/Colors/Iron_S/SR.png")
		[304]:
			return ("res://PNG/Mobs/Colors/Iron_S/SSR.png")
		_:pass

func mobs_init():
	var j=0
	for i in mobs:
		var temp=i.instantiate()
		self.get_node(Glo.world_path).add_child(temp)
		temp.global_position=Vector2(1000,0)
		temp.add_to_group("NoGravity_Myrigid")
		mobs[j]=temp
		j+=1

func material_change(type):
	for i in get_tree().get_nodes_in_group("NoGravity_Myrigid"):
		i.material_type=type
		i.no_connect_init()
	button_texture_change()
	
func _process(_delta):
	var j=0
	var is_hover=false
	for i in mob_button_Container.get_children():
		if i.is_hovered():
			is_hover=true
			Glo.hover_node=mobs[j]
			if Input.is_action_just_pressed("ui_accept"):
				spawn_mob(mobs[j])
				var temp=un_init_mobs[j].instantiate()
				self.get_node(Glo.world_path).add_child(temp)
				temp.global_position=Vector2(1000,0)
				temp.add_to_group("NoGravity_Myrigid")
				mobs[j]=temp
				material_change(materail_type)
		j+=1
	if  is_hover==false:
		Glo.hover_node=null

func spawn_mob(mob:MyRigidClass):
	await get_tree().create_timer(0.05).timeout
	mob.global_translate(get_node(Glo.world_path).get_global_mouse_position())
	Glo.pick_node=mob
	mob.remove_from_group("NoGravity_Myrigid")

func no_enough_money_tip():
	Tip_label.visible=true
	await get_tree().create_timer(1).timeout
	Tip_label.visible=false

func _on_next_materail_button_down():
	if materail_type<304:
		if materail_type%10<4:
			materail_type+=1
		elif materail_type%10>=4:
			materail_type+=100
			materail_type-=3
	else :
		materail_type=101
	material_change(materail_type)
