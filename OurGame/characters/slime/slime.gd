extends Node2D


func play_walk():
	%AnimationPlayer.play("walk")
	print("slime script play walk")


func play_hurt():
	%AnimationPlayer.play("hurt")
	print("slime script play hurt")
	%AnimationPlayer.queue("walk")
	print("slime script play walk after hurt")
