extends Node2D

func _process(_delta):
#当按下对应键盘按键时，也可以是特定按钮
	if Input.is_action_just_pressed("ui_save"):
#new一个PackedScene
		var save_assemblys=PackedScene.new()
#重设所有节点的owner
		for i in self.get_children():
			i.owner=self
#打包保存
		save_assemblys.pack(self)
		ResourceSaver.save(save_assemblys,"res://saves/save_assemblys.tscn")
	pass
