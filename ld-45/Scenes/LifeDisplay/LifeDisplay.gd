extends Label

export(int) var life = 3 setget set_life

func _ready():
	update_text()

func update_text():
	text = "Life: " + String(life) + "       "

func set_life(value: int) -> void:
	life = value # wholesome
	update_text()
	