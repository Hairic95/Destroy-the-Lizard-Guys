extends Node2D

var waves = [
	load("res://src/Wave/Wave.tscn"),
	load("res://src/Wave/Wave1.tscn"),
	load("res://src/Wave/Wave2.tscn"),
	load("res://src/Wave/Wave3.tscn"),
	load("res://src/Wave/Wave4.tscn"),
]
func _ready():
	randomize()
	spawn_new_wave()
var spawn_timer = 16.0
var spawn_count = 0

var wave_defeated = 0

func _process(d):
	
	if spawn_timer < spawn_count:
		if check_enemies() < 15:
			spawn_new_wave()
			spawn_count = 0
		else:
			spawn_count = spawn_count / 2
		
	
	spawn_count += d
	

export (PackedScene) var spanwer_ref
export (PackedScene) var running_enemy_ref
signal new_wave

func spawn_new_wave():
	
	if spawn_timer >= 5 and wave_defeated%3 == 0:
		spawn_timer -=1.2
	
	var new_wave = waves[randi()%waves.size()].instance()
	
	add_child(new_wave)
	
	for pos in new_wave.get_children():
		var new_spawner = spanwer_ref.instance()
		
		add_child(new_spawner)
		
		new_spawner.enemy_to_spawn = running_enemy_ref.instance()
		new_spawner.set_position(pos.get_position())
		new_spawner.connect("creature_spawned", self, "add_enemy")
	
	new_wave.queue_free()
	
	wave_defeated += 1
	emit_signal("new_wave", wave_defeated)

signal enemy_to_connect(enemy_ref)
func add_enemy(enemy, pos):
	add_child(enemy)
	enemy.set_position(pos)
	
	enemy.connect("dead", self, "check_enemies")
	emit_signal("enemy_to_connect", enemy)

func check_enemies():
	
	var enemy_left = []
	
	for child in get_children():
		if child is Enemy and !child.is_dying:
			enemy_left.append(child)
	
	if enemy_left.empty():
		spawn_new_wave()
		spawn_count = 0
	
	return enemy_left.size()
