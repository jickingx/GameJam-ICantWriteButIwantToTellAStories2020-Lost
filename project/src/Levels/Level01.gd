extends Node2D
const Explosion = preload("res://src/FX/Particles/Explosion.tscn")

export (String, FILE) var next_scene
var is_area_left_hit := false
var is_area_center_hit := false
var is_area_right_hit := false
var has_activated_falling_platform := false
var text_delay := .8

var text_0 = "clues must be around?"
var text_1 = "from random screetches and sparks"
var text_2 = "but they do not seem to make any sense"

var text_3 = "when all hope seemed lost, it unvieled itself"
var text_4 = "where will this lead you?"
var text_5 = "alone, you faced the unknown"
var text_6 = "with hopes that you'll find yourself at the end"
var text_7 = "until next time you get..."


func _ready():
	$Player.can_move = false


func _input(event):
	if has_activated_falling_platform && (event.is_action_pressed("ui_left") || event.is_action_pressed("ui_right")):
		has_activated_falling_platform = false
		destroy_platform()


func destroy_platform():
	#SHOW PARTICLES
	var e = Explosion.instance()
	Global.current_scene.add_child(e)
	e.position = $StaticBody2D.global_position
	
	$AudioExplosion.play()
	$Textbox.hide()
	$StaticBody2D.queue_free()


func _on_AreaLeft_body_entered(body):
	if body.is_in_group("players"):
		is_area_left_hit = true
		$AreaLeft.queue_free()
		if is_area_right_hit:
			$Textbox.show(text_2)
		else:
			$Textbox.show(text_1)
		$Player.can_move = false
		$AudioCoin.play()
		yield($AudioCoin, "finished")
		$Player.can_move = true
		yield(get_tree().create_timer(text_delay), "timeout")
		$Textbox.hide()


func _on_AreaRight_body_entered(body):
	if body.is_in_group("players"):
		is_area_right_hit = true
		$AreaRight.queue_free()
		if is_area_left_hit:
			$Textbox.show(text_2)
		else:
			$Textbox.show(text_1)
		$Player.can_move = false
		$AudioCoin.play()
		yield($AudioCoin, "finished")
		$Player.can_move = true
		yield(get_tree().create_timer(text_delay), "timeout")		
		$Textbox.hide()


func _on_AreaCenter_body_entered(body):
	#FIRST COLLISION
	if body.is_in_group("players") && not is_area_center_hit:
		is_area_center_hit = true
		$Textbox.show(text_0)
		$Player.can_move = false
		$AudioCoin.play()
		yield(get_tree().create_timer(text_delay), "timeout")
		$Player.can_move = true
		yield(get_tree().create_timer(text_delay), "timeout")
		$Textbox.hide()


	#TRIGGER EXPLOSION
	if body.is_in_group("players") && is_area_left_hit && is_area_right_hit:
		$Player.can_move = false
		$AreaCenter.queue_free()
		$AudioQuake.play()
		$Player/Camera2D.shake()
		yield($AudioQuake, "finished")
		$Textbox.show(text_3)
		yield(get_tree().create_timer(text_delay), "timeout")
		has_activated_falling_platform = true


func _on_AreaBottom_body_entered(body):
	if body.is_in_group("players"):
		$AreaBottom.queue_free()
		$Player/Camera2D.shake()
		$Textbox.show(text_4)
		$AudioQuake.play()
		yield($AudioQuake, "finished")
		$Player.can_move = true
		yield(get_tree().create_timer(text_delay), "timeout")
		$Textbox.hide()


func _on_AreaBottom2_body_entered(body):
	if body.is_in_group("players"):
		$AreaBottom2.queue_free()
		$Textbox.show(text_5)
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
		$Textbox.show(text_6)
		yield(get_tree().create_timer(1.2), "timeout")
		$Textbox.hide()
		yield(get_tree().create_timer(text_delay), "timeout")
		$Textbox.show(text_7)
		yield(get_tree().create_timer(1.2), "timeout")
		$Textbox.hide()
		Global.switch_scene(next_scene)
