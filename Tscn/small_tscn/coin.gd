extends MyRigidClass
@onready var init_rand_vec=Vector2.RIGHT
@onready var target_vec=Vector2.ZERO
func _ready():
	MyRigidClass_init()
	randomize()
	var rand_angel=randf_range(0,360)
	init_rand_vec=init_rand_vec.rotated(deg_to_rad(rand_angel))
	lerp_to_randvec()
	await get_tree().create_timer(1).timeout
	lerp_to_zero()

func _physics_process(_delta):
	var force_to_player:Vector2=Glo.player_pos-self.global_position
	constant_force=force_to_player*8*mass
func lerp_to_randvec():
	linear_velocity=init_rand_vec*70

func lerp_to_zero():
	linear_velocity=Vector2.ZERO

func _on_area_2d_body_entered(body):
	if body.is_in_group("Assembly_0"):
		PlayerData.player_coin[material_type]+=1
		self.queue_free()
