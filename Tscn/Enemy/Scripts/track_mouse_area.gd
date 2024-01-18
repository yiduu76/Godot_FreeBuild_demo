extends Sprite2D
var Traking_buidable_area


func _ready():
	pass
func _process(_delta):
	auto_attch()
	self.global_position=get_global_mouse_position()+Vector2(2,2)

func auto_attch():
	
	if Glo.pick_node!=null&&Traking_buidable_area!=null:
		Glo.pick_node.global_position=Traking_buidable_area.global_position
	elif Glo.pick_node!=null&&Traking_buidable_area==null:
		Glo.pick_node.global_position=get_global_mouse_position()
	elif Glo.pick_node==null:
		Traking_buidable_area=null

func _on_track_mouse_area_area_entered(area):
	if area.is_in_group("build_able_area")&&Glo.pick_node!=null:
		if area.get_parent()!=Glo.pick_node&&area.get_parent().Father_node!=Glo.pick_node:
			Traking_buidable_area=area

func _on_track_mouse_area_area_exited(area):
	if area==Traking_buidable_area:
		Traking_buidable_area=null

func _on_lock_target_area_body_entered(body):
	if body.has_signal("EnemyClass"):
		Glo.lock_target=body

func _on_lock_target_area_body_exited(body):
	if body.has_signal("EnemyClass"):
		Glo.lock_target=null
