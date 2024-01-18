extends Polygon2D
@export_range(0.01, 1, 0.01) var min_alpha := 0.05
@export_range(0.1, 50, 0.01) var texture_epsilon := 1
@export_range(-50, 50, 1) var margin_pixels := 0

func _ready():
	_create_polygon2d()
func poly_num_count():
	var poly_num=_create_external_vertices_from_texture(texture).size()
	pass
	
func _create_polygon2d():
	if texture != null:
		var outside_polygon = _create_external_vertices_from_texture(texture)
		$"../CollisionPolygon2D".set_polygon(PackedVector2Array(outside_polygon[0]))
		set_polygon(PackedVector2Array(outside_polygon[0]))

func _create_external_vertices_from_texture(texture):
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(texture.get_image(), min_alpha)
	var rect = Rect2(0, 0, texture.get_width(), texture.get_height())
	if margin_pixels != 0:
		bitmap.grow_mask(margin_pixels, rect)
	var poly = bitmap.opaque_to_polygons(rect, texture_epsilon)
	return poly
