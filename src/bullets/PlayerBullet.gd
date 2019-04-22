extends Area2D

var dir = Vector2(1, 0)

var speed = 300

var lifetime = 2.2
var lifecount = 0

func _ready():
	pass # Replace with function body.

func _physics_process(d):
	
	set_global_position(get_global_position() + d * dir * speed)
	
	lifecount += d
	if lifecount > lifetime:
		queue_free()
	

func set_bullet(start_pos, dir):
	set_global_position(start_pos)
	self.dir = dir
	set_rotation(dir.angle())

signal enemy_hurt(self_ref, enemy)


func _on_playerBullet_body_entered(body):
	if body.get_groups().has("enemy"):
		emit_signal("enemy_hurt", self, body)
		queue_free()


func _on_ground_check_body_entered(body):
	if body.get_groups().has("ground"):
		queue_free()
		
