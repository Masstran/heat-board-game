extends Node2D

class_name Card

enum Symbol {PLUS, HEAT, COOL, CANT_DISCARD}

@export var value = 0
@export var isHeat = false
@export var isStress = false
@export var isUpgrade = false
@export var symbols: Array[Symbol]
@export var text_scene: TextEdit
var isDefault

func toString():
	var string = "Value: %d\nSymbols: %s\nisHeat: %s\nisStress: %s\nisUpgrade: %s\nisDefault: %s"
	return string % [value, str(symbols.map(func(x): return Symbol.find_key(x))), isHeat, isStress, isUpgrade, isDefault]

func _ready() -> void:
	isDefault = not(isHeat or isStress or isUpgrade)
	text_scene.text = toString()
