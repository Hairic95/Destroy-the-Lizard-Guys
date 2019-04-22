extends Control


func _ready():
	randomize()
	
	$entities.connect("enemy_to_connect", self, "connect_enemy_to_money")
	$entities.connect("new_wave", self, "update_waves")
	
	$entities/MapPlayer.connect("shoot_fired", self, "create_bullet")
	$entities/MapPlayer.connect("game_over", self, "game_over")
func connect_enemy_to_money(enemy):
	enemy.connect("explode_coins", self, "create_many_coins")

export (PackedScene) var smallCoin_ref
export (PackedScene) var bigCoin_ref

func create_many_coins(pos, amount):
	
	for i in range(amount):
		var coin = bigCoin_ref.instance()
		if !randi()%5 != 0:
			coin = smallCoin_ref.instance()
		create_coin(coin, pos)
	

func create_coin(coin, start_pos):
	
	$coins.add_child(coin)
	
	coin.set_position(start_pos)
	coin.connect("collected", self, "get_coin_points")
	

var points = 0

var sound_stack = []

func get_coin_points(coin):
	
	points += coin.points
	$entities/MapPlayer.play_pick_up_sound()
	$UI/Points/value.set_text(str(points))

func create_bullet(bullet_instance, start_pos, dir):
	
	$bullets.add_child(bullet_instance)
	
	bullet_instance.set_bullet(start_pos, dir)
	bullet_instance.connect("enemy_hurt", self, "damage_enemy")

func damage_enemy(bullet, enemy):
	enemy.health -= 1
	if enemy.health <= 0:
		enemy.die()
	else:
		enemy.knockback(bullet.dir)

func retry():
	get_tree().change_scene("res://src/Levels/Level_0.tscn")
func update_waves(wave):
	
	$UI/Waves/value.set_text(str(wave))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func game_over():
	
	if score.best_score.points < points:
		score.best_score = {"points" : points, "waves" : $entities.wave_defeated}
	
	get_tree().change_scene("res://src/Menus/GameOver.tscn")
	

func _on_music_stream_finished():
	$music_stream.play()
