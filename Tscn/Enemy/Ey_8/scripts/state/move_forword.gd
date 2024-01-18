extends State
func enter():
	player=owner
func exit():
	pass
func update(_delta):
	move()
	owner.animation_node.play(self.name)
	tran_state()

func move():
	pass

func tran_state():
	pass
#	if player.finish_anim==self.name&&player.finish==true:
#		var rand_num=randf_range(0,100)
#		if rand_num<=30:
#			state_machine.transition_to("attk_1_end")
#		else :
#			state_machine.transition_to("jump")
#		player.finish=false
#		return
