extends Node2D


func play_idle_animation():
	%AnimationPlayer.play("idle")
	print("happyboo script play idle")


func play_walk_animation():
	%AnimationPlayer.play("walk")
	print("happyboo script play walk")
