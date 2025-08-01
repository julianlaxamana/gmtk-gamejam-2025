extends Node

var cursorGrab = false
var inventory = []
var editor
var disableMouse = false

var selectedUnit
var unitScripts = {
}

var path_node

const BUG_SPRITE_DICTIONARY = {
	"meep": preload("res://Assets/Bugs/meep.png"),
	"fob": preload("res://Assets/Bugs/meep.png"),
	"borf": preload("res://Assets/Bugs/bug_basic.png"),
	"spoid": preload("res://Assets/Bugs/bug_basic.png"),
	"tiny_spoid": preload("res://Assets/Bugs/bug_basic.png"),
	"bleep": preload("res://Assets/Bugs/bug_basic.png"),
	"zonk": preload("res://Assets/Bugs/zonk.png"),
	"lez_tail": preload("res://Assets/Bugs/bug_basic.png"),
	"lez_middle": preload("res://Assets/Bugs/bug_basic.png"),
	"lez_head": preload("res://Assets/Bugs/bug_basic.png"),
	"smorg": preload("res://Assets/Bugs/bug_basic.png"),
}
