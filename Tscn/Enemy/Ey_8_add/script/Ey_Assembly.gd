extends Node2D
@onready var material_type=101
@onready var is_random=false

func _ready():
	pass

func _physics_process(_delta):
	rest_control()
	if material_type!=101:
		match_material_type()
func rest_control():
	var child_num=self.get_child_count()
	if child_num<=0:
		self.queue_free()
func match_material_type():
	for i in self.get_children():
		if i.has_signal("EnemyClass"):
			i.is_random=is_random
			i.material_type=material_type
			i.no_connect_init()

