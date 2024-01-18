extends Node
@onready var point_array=[]
@onready var line_size=1
@export var path_length=21
@onready var line_node=$line
func _ready():
	pass

func _physics_process(_delta):
	line_node.points=point_array
	line_node.width=line_size
	
	if point_array.size()>=path_length:
		point_array.remove_at(0)
func line_color_match():
	
	pass
func icon_swap_color(path):
	line_node.texture=load(path)

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
