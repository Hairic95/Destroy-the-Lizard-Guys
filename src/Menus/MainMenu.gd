extends Control

func _on_StartButton_pressed():
	$select_stream.play()
	get_tree().change_scene("res://src/Levels/Level_0.tscn")


func _on_music_stream_finished():
	$music_stream.play()
