extends Control

func _ready():
	$points/value.set_text(str(score.best_score.points))
	$Waves/value.set_text(str(score.best_score.waves))

func _on_PlayAgain_pressed():
	get_tree().change_scene("res://src/Levels/Level_0.tscn")


func _on_music_stream_finished():
	$music_stream.play()
