extends Node2D

export (String, FILE) var next_scene
var is_area_left_hit := false
var is_area_center_hit := false
var is_area_right_hit := false
var has_activated_falling_platform := false
var text_delay := .8


func _input(event):
	if has_activated_falling_platform && (event.is_action_pressed("ui_left") || event.is_action_pressed("ui_right")):
		has_activated_falling_platform = false
		destroy_platform()


func destroy_platform():
	#SHOW PARTICLES
	$Textbox.hide()
	$StaticBody2D.queue_free()


func _on_AreaLeft_body_entered(body):
	if body.is_in_group("players"):
		is_area_left_hit = true
		$AreaLeft.queue_free()
		$Textbox.show("Test test test text that makes no sense?")
		$Player.can_move = false
		yield(get_tree().create_timer(text_delay), "timeout")
		$Player.can_move = true
		yield(get_tree().create_timer(text_delay), "timeout")		
		$Textbox.hide()


func _on_AreaRight_body_entered(body):
	if body.is_in_group("players"):
		is_area_right_hit = true
		$AreaRight.queue_free()
		$Textbox.show("Test test test text that makes no sense?")
		$Player.can_move = false
		yield(get_tree().create_timer(text_delay), "timeout")
		$Player.can_move = true
		yield(get_tree().create_timer(text_delay), "timeout")		
		$Textbox.hide()


func _on_AreaCenter_body_entered(body):
	if body.is_in_group("players") && is_area_left_hit && is_area_right_hit:
		is_area_center_hit = true
		$Player.can_move = false
		$AreaCenter.queue_free()
		$Player/Camera2D.shake()
		$Textbox.show("Test test test text that makes no sense?")
		yield(get_tree().create_timer(text_delay), "timeout")
		has_activated_falling_platform = true


func _on_AreaBottom_body_entered(body):
	if body.is_in_group("players"):
		$AreaBottom.queue_free()
		$Player/Camera2D.shake()
		$Textbox.show("Test test test text that makes no sense?")
		yield(get_tree().create_timer(text_delay), "timeout")
		$Player.can_move = true
		yield(get_tree().create_timer(text_delay), "timeout")
		$Textbox.hide()


func _on_AreaBottom2_body_entered(body):
	if body.is_in_group("players"):
		$AreaBottom2.queue_free()
		$Textbox.show("Test test test text that makes no sense?")
		$Player.can_move = false
		yield(get_tree().create_timer(text_delay), "timeout")
		$Player.can_move = true


func _on_AreaBottom3_body_entered(body):
	if body.is_in_group("players"):
		$AreaBottom3.queue_free()
		$Textbox.hide()


func _on_Npc00_body_entered(body):
	if body.is_in_group("players"):
		$Player.can_move = false
		yield(get_tree().create_timer(text_delay), "timeout")
		$Textbox.show("is this the end?")
		yield(get_tree().create_timer(1.2), "timeout")
		$Textbox.hide()
		yield(get_tree().create_timer(text_delay), "timeout")
		$Textbox.show("well see each other again...")
		yield(get_tree().create_timer(1.2), "timeout")
		$Textbox.hide()
		Global.switch_scene(next_scene)

