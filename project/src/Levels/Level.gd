extends Node2D

export (String, FILE) var next_scene
export var text_delay = .4
var text00 := "you found yourself, deep in the dark"
var can_move_next := false
var text_counter := 0

func _ready():
	yield(get_tree().create_timer(text_delay), "timeout")
	$Textbox.show(text00)
	yield(get_tree().create_timer(text_delay), "timeout")
	can_move_next = true

func _input(event):
	if not can_move_next:
		return
	if event.is_action_pressed("ui_left") || event.is_action_pressed("ui_right"):
		can_move_next = false
		if text_counter >= 3:
			Global.switch_scene(next_scene)
		else:
			match text_counter:
				0:
					$Textbox.show("no idea where and who you are")
					yield(get_tree().create_timer(text_delay), "timeout")
					can_move_next = true
				1:
					$Textbox.show("then something happened...")
					$AudioStreamPlayer.play()
					yield($AudioStreamPlayer, "finished")
					can_move_next = true
				2:
					$Textbox.show("you started crashing into ground")
					yield(get_tree().create_timer(text_delay), "timeout")
					can_move_next = true
			text_counter += 1







