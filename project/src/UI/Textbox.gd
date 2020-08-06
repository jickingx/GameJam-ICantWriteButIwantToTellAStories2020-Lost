extends CanvasLayer


func _ready():
	hide()


func show(text):
	$Label.text = text
	$Label.visible = true


func hide():
	$Label.visible = false

