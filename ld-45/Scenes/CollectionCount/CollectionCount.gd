extends Label

export(int) var totalCount = 26
var collected: int = 0

func _ready():
	update_text()

func update_text():
	text = "Collected " + String(collected) + "/" + String(totalCount)

func increment() -> void:
	collected = collected + 1