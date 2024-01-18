extends GPUParticles2D
@onready var icon_texture=self.texture
@onready var material_type:int=101
var icon
func _ready():
	icon=self
	var sound=self.get_node_or_null("AudioStreamPlayer2D")
	if sound!=null:
		$AudioStreamPlayer2D.playing=true
	icon.material.set_shader_parameter("palette_out",load("res://PNG/Mobs/Colors/Wood/N.png"))
	icon.material.set_shader_parameter("palette_in",load("res://PNG/Mobs/Colors/Wood/N.png"))
	icon_change(material_type)
	self.emitting=true

func _on_timer_timeout():
	self.queue_free()

func icon_swap_color(path):
	icon.material.set_shader_parameter("palette_out",load(path))

func icon_change(type):
	match [type]:
		[101]:
			icon_swap_color("res://PNG/Mobs/Colors/Wood/N.png")
		[102]:
			icon_swap_color("res://PNG/Mobs/Colors/Wood/R.png")
		[103]:
			icon_swap_color("res://PNG/Mobs/Colors/Wood/SR.png")
		[104]:
			icon_swap_color("res://PNG/Mobs/Colors/Wood/SSR.png")
		[201]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_T/N.png")
		[202]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_T/R.png")
		[203]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_T/SR.png")
		[204]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_T/SSR.png")
		[301]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_S/N.png")
		[302]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_S/R.png")
		[303]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_S/SR.png")
		[304]:
			icon_swap_color("res://PNG/Mobs/Colors/Iron_S/SSR.png")
		_:pass
