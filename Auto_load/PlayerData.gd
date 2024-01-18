extends Node
@onready var player_coin={
	101:0,102:0,103:0,104:0,
	201:0,202:0,203:0,204:0,
	301:0,302:0,303:0,304:0,
}
@onready var P_MaxPower=0
@onready var P_PowerRecoverSpeed=0
@onready var power=0
@onready var total_value=0

@onready var Sum_ShootCd_Decrese=0
@onready var Sum_OnceBulletNum_Add=0
@onready var Sum_Bullet_InitSpeed_Add=0

func _ready():
	self.process_mode=Node.PROCESS_MODE_ALWAYS

func _physics_process(delta):
	data_update()
	
	power+=P_PowerRecoverSpeed*delta
	power=clamp(power,0,P_MaxPower)

func data_update():
	var mobs=get_tree().get_nodes_in_group("Assembly_0")
	power_data_up(mobs)
	Shoot_data_up(mobs)
	total_value=value_upgrade()
func Shoot_data_up(mobs_array):
	var temp_ShootCd_Decrese=0
	var temp_OnceBulletNum_Add=0
	var temp_Bullet_InitSpeed_Add=0
	for i in mobs_array:
		temp_ShootCd_Decrese+=i.S_ShootCd_Decrese
		temp_OnceBulletNum_Add+=i.S_OnceBulletNum_Add
		temp_Bullet_InitSpeed_Add+=i.S_Bullet_InitSpeed_Add
	Sum_ShootCd_Decrese=temp_ShootCd_Decrese
	Sum_OnceBulletNum_Add=temp_OnceBulletNum_Add
	Sum_Bullet_InitSpeed_Add=temp_Bullet_InitSpeed_Add
	
func power_data_up(mobs_array):
	var temp_max_power=0
	var temp_power_recover_speed=0
	for i in mobs_array:
		temp_max_power+=i.P_MaxPower_add
		temp_power_recover_speed+=i.P_PowerRecoverSpeed_add
	P_MaxPower=temp_max_power
	P_PowerRecoverSpeed=temp_power_recover_speed

func value_upgrade():
	var temp_value=0
	var temp_value_1=0
	var temp_groups=get_tree().get_nodes_in_group("Assembly_0")
	for i in temp_groups:
		temp_value_1+=i.value

	var temp_value_2=0
	for i in player_coin:
		temp_value_2+=player_coin[i]

	temp_value=temp_value_1+temp_value_2
	return temp_value
