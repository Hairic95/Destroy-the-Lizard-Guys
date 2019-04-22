extends Sprite

func _ready():
	$anim.play("start")

var enemy_to_spawn
signal creature_spawned(dude)

func spawn_dude():
	emit_signal("creature_spawned", enemy_to_spawn, get_position())


func _on_anim_animation_finished(anim_name):
	match(anim_name):
		"start":
			spawn_dude()
			$anim.play("end")
		"end":
			queue_free()