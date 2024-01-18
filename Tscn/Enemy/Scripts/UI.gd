extends Control
@onready var coin_label=$Shop
@onready var Ammon_bar=$Ammon_bar
@onready var Reward_ui=$Reward
@onready var Ey_spawn_bar=$wave_ui/Ey_spawn_bar

func _process(_delta):
#	coin_label.text=str(int(PlayerData.player_coin[101]))
	Ey_spawn_bar.max_value=Glo.spawn_need_tick
	Ey_spawn_bar.value=Glo.spawn_tick
	var temp_y=160-PlayerData.power*10
	Ammon_bar.points[1].y=clampf(temp_y,0,160.01)
	coin_label.text=str(int(PlayerData.player_coin[303]))

func _on_shop_button_down():
	Reward_ui.visible=!Reward_ui.visible

func _on_next_wave_button_button_down():
	Glo.spawn_tick=Glo.spawn_need_tick
