extends Camera2D
@onready var driving=false
@onready var drag_start_pos=Vector2.ZERO
@onready var camera_velocity=Vector2.ZERO
@onready var target_zoom:Vector2=Vector2(1,1)

func _physics_process(_delta):
	self.zoom=lerp(self.zoom,target_zoom,0.1)
	
	if Input.is_action_just_pressed("ui_zoom_here"):
		drag_start_pos=get_global_mouse_position()
		
	if Input.is_action_just_released("ui_zoom_here"):
		camera_velocity=drag_start_pos-get_global_mouse_position()
		self.global_position+=camera_velocity
	
	if Glo.build_mode==true:
		pass
	elif Glo.build_mode==false:
		self.global_position=Glo.player_pos

	if Input.is_action_just_pressed("ui_show"):
		driving=!driving
	if Input.is_action_just_pressed("ui_zoom_in"):
		target_zoom+=Vector2(0.1,0.1)
	elif Input.is_action_just_pressed("ui_zoom_out"):
		target_zoom-=Vector2(0.1,0.1)
	target_zoom=target_zoom.clamp(Vector2(0.6,0.6),Vector2(3.0,3.0))

func _on_area_2d_area_entered(_area):
	pass
#	if area.has_node("CollisionShape2D"):
#		var rect=area.get_node("CollisionShape2D")
#		if area.is_in_group("camera2D_area"):
#			self.limit_bottom=rect.global_position.y+rect.shape.size.y/2
#			self.limit_top=rect.global_position.y-rect.shape.size.y/2
#			self.limit_left=rect.global_position.x-rect.shape.size.x/2
#			self.limit_right=rect.global_position.x+rect.shape.size.x/2
