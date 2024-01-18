extends Control
var hover_node
@onready var Pre_name_node=$LV_1/LV_2_top/Names/Pre_name
@onready var Material_Name_node=$LV_1/LV_2_top/Names/Material_Name
@onready var Main_Name_node=$LV_1/LV_2_top/Names/Main_name
@onready var Mass_node=$LV_1/LV_2_left/Nor_data/nums/Mass
@onready var Health_node=$LV_1/LV_2_left/Nor_data/nums/Health
@onready var Recover_node=$LV_1/LV_2_left/Nor_data/nums/Recover
@onready var physics_additon_node=$LV_1/LV_2_left/Nor_data/nums/physics_additon
@onready var physics_resist_node=$LV_1/LV_2_left/Nor_data/nums/physics_resist
@onready var energy_additon_node=$LV_1/LV_2_left/Nor_data/nums/energy_additon
@onready var energy_resist_node=$LV_1/LV_2_left/Nor_data/nums/energy_resist
@onready var Value_node=$LV_1/LV_2_left/Nor_data/nums/Value

@onready var ShootCd_node=$LV_1/LV_2_left/Nor_data/nums2/ShootCd
@onready var OnceBulletNum_node=$LV_1/LV_2_left/Nor_data/nums2/OnceBulletNum
@onready var Bullet_InitSpeed_node=$LV_1/LV_2_left/Nor_data/nums2/Bullet_InitSpeed
@onready var Bullet_Change_node=$LV_1/LV_2_left/Nor_data/nums2/Bullet_Change
func _process(_delta):
	hover_node=Glo.hover_node
	if hover_node!=null:
		self.visible=true
		var mass_num=int(hover_node.mass*100)
		mass_num=float(mass_num)/100
		
		Pre_name_node.text="普通的"
		Material_Name_node.text=return_material_name(hover_node.material_type)
		Main_Name_node.text=str(hover_node.CN_name)
		
		Mass_node.text=str(mass_num)
		Health_node.text=str(hover_node.health)
		Recover_node.text=str(hover_node.shape_recover_scale+hover_node.materia_recover_scale)
		physics_additon_node.text=str(hover_node.shape_physics_additon+hover_node.materia_physics_additon)
		physics_resist_node.text=str(hover_node.shape_physics_resist+hover_node.materia_physics_resist)
		energy_additon_node.text=str(hover_node.shape_energy_additon+hover_node.materia_energy_additon)
		energy_resist_node.text=str(hover_node.shape_energy_resist+hover_node.materia_energy_resist)
		Value_node.text=str(hover_node.value)
		
		ShootCd_node.text=str(hover_node.S_ShootCd_Decrese)
		OnceBulletNum_node.text=str(hover_node.S_OnceBulletNum_Add)
		Bullet_InitSpeed_node.text=str(hover_node.S_Bullet_InitSpeed_Add)
		Bullet_Change_node.text=str(hover_node.special_bullet_name)
	else :
		self.visible=false

func return_material_name(type):
	match [type]:
		[101]:return "松木"
		[102]:return "红木"
		[103]:return "紫木"
		[104]:return "乌木"
		[201]:return "铁"
		[202]:return "铀"
		[203]:return "钨"
		[204]:return "钨钢"
		[301]:return "铜"
		[302]:return "银"
		[303]:return "金"
		[304]:return "秘银"
		_:return "松木"
