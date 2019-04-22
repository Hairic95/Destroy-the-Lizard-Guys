extends KinematicBody2D
class_name Enemy


var health = 2

func _ready():
	randomize()
	$Sprite/anim.play("idle")

var speed = Vector2(100, 0)
var currentVelocity = Vector2(0, 1)

var change_state_time = 2.0
var change_state_count = 0

var majorState = "idle"

func _physics_process(d):
	
	if !is_dying:
		
		if change_state_time < change_state_count:
			if currentState != "idle":
				change_state("idle")
				majorState = "idle"
			else:
				change_state("run")
				majorState = "run"
			change_state_count = 0
		else:
			change_state_count += d
		
		if !is_on_floor():
			speed.y += 350 * d
		else:
			speed.y = 0
		
		
		
		var movement = move_and_slide(speed * currentVelocity, Vector2(0, -1))
		
		if movement.y != 0:
			change_state("in_air")
		else:
			if movement.x != 0:
				change_state("run")
			else:
				if majorState == "run":
					if !enemies_to_view.empty():
						currentVelocity.x = -currentVelocity.x
				else:
					change_state("idle")
				
				if currentVelocity.x > 0:
					change_facing("right")
				else:
					change_facing("left")

var currentFacing = "right"

func change_facing(dir):
	
	if currentFacing != dir:
		if dir == "right":
			$Sprite.set_scale(Vector2(1, 1))
		elif dir == "left":
			$Sprite.set_scale(Vector2(-1, 1))
		
		currentFacing = dir
		

var currentState = "idle"
func change_state(newState):
	if currentState != newState:
		currentState = newState
		match(newState):
			"run":
				var dir = 1
				if randi()%2 == 0:
					dir = -1
				
				if currentFacing == "right" and dir == -1:
					change_facing("left")
				if currentFacing == "left" and dir == 1:
					change_facing("right")
				
				currentVelocity.x = dir
			"idle":
				currentVelocity.x = 0
			
		
		$Sprite/anim.play(newState)

func knockback(dir):
	
	pass

var is_dying = false

signal explode_coins(pos, amount)
signal dead()


func die():
	is_dying = true
	$hurtBox.queue_free()
	$CollisionShape2D.queue_free()
	$Sprite/anim.play("die")
	$dying_stream.play()
	
	emit_signal("explode_coins", get_global_position(), randi()%2 + 3)
	emit_signal("dead")


func _on_anim_animation_finished(anim_name):
	if anim_name == "die":
		queue_free()


func _on_bounce_checker_body_entered(body):
	if !body.get_groups().has("ground"):
		speed.y = -100

var enemies_to_view = []

func _on_vision_body_entered(body):
	if body.get_groups().has("enemy") or body.get_groups().has("ground"):
		enemies_to_view.append(body)


func _on_vision_body_exited(body):
	if (body.get_groups().has("enemy") or body.get_groups().has("ground")) and enemies_to_view.has(body):
		enemies_to_view.erase(body)
