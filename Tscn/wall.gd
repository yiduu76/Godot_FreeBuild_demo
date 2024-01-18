extends MyRigidClass
@onready var line_node_1=$Line2D_1
@onready var sun=$sun
@onready var swing_tick=3
@onready var tick=0

var init_points
var target_points
var sun_color

func _ready():
	no_connect_init()
	init_points=spawn_circle_points(320)
	target_points=init_points
	line_node_1.points=init_points
	sun_color=sun.color
	
func _physics_process(delta):
	limit_speed(4.0)
	sun_color.h+=0.001*delta
	sun.color.h=sun_color.h
	line_node_1.default_color=sun_color
	line_node_1.default_color.s=0.35
	
	add_edge_force()
	add_center_force()
	Glo.sun_pos=self.global_position
	
func add_edge_force():
	for i in get_tree().get_nodes_in_group("MyRigidClass"):
		match [i.has_signal("BulletClass")||i.is_in_group("NoGravity_Myrigid")]:
			[true]:
				pass
			_:
				var temp_force:Vector2=self.global_position-i.global_position
				var temp_len=temp_force.length()
				if temp_len>=300:
					if i.is_in_group("NoGravity_Myrigid"):
						pass
					else :
						i.apply_central_force(temp_force/2.0)
						self.apply_central_force(-temp_force/2.0)

func add_center_force():
	for i in get_tree().get_nodes_in_group("MyRigidClass"):
		var temp_force:Vector2=self.global_position-i.global_position
		var temp_len=temp_force.length()
		if temp_len<=32:
			temp_force=temp_force.normalized()
			i.apply_central_force(-temp_force*320)
	
func spawn_circle_points(radius):
	var seg=int(radius/2)
	var points_array=[]
	var seg_num=seg+1
	for i in seg_num:
		points_array.append(Vector2.ZERO)
	for i in seg_num:
		var angel=(i)*(360.0/seg)
		points_array[i]=Vector2(radius*cos(deg_to_rad(angel)),radius*sin(deg_to_rad(angel)))
	return points_array
