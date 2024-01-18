extends Area2D
@export var Effect_strength=28
func _on_body_entered(body):
	if body.has_signal("BulletClass"):
		body.beEffecting=true
		body.Effect_souce=self
		body.Effect_strength=Effect_strength
		
func _on_body_exited(body):
	if body.has_signal("BulletClass"):
		body.beEffecting=false
		body.Effect_souce=null
