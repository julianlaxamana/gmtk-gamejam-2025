extends Node

var cursorGrab = false
var inventory = []
var editor
var disableMouse = false

var selectedUnit
var unitScripts = {
}

var path_node
var battlefield
var grid
## Weights
var blockTypeWeights = {
	"attack": 0.5,
	"projectile": 0.5
}

var attackWeights = {
	"basic": 0.25,
	"radial": 0.25,
	"gatling": 0.25,
	"spread": 0.25
}

var projectileWeights = {
	"chain": 0.20,
	"homing": 0.20,
	"melee": 0.20,
	"ranged": 0.20,
	"spike": 0.20
}

## BLOCKS

var BLOCKS_DICTIONARY = {
	"attack" = {
		"basic" = (func ():
	var blockScene = preload("res://scenes/Blocks/loop_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "basic_shoot ("
	block.unit = Global.selectedUnit
	block.variable = preload("res://scenes/Blocks/Attacks/Basic/basic.tscn")
	print(block.variable)
	block.bottomText = ")"
	block.test = func (obj):
		if obj.get_child(9).get_child_count() == 1 && "variable" in obj.get_child(9).get_child(0):
			var attack = obj.variable.instantiate()
			attack.projectile = obj.get_child(9).get_child(0).variable
			obj.unit.add_child(attack)
	return block		
	),
			
		"radial" = (func ():
	var blockScene = preload("res://scenes/Blocks/loop_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "radial_shoot ("
	block.unit = Global.selectedUnit
	block.variable = preload("res://scenes/Blocks/Attacks/Radial/radial.tscn")
	block.bottomText = ")"
	block.test = func (obj):
		if obj.get_child(9).get_child_count() == 1 && "variable" in obj.get_child(9).get_child(0):
			var attack = obj.variable.instantiate()
			attack.projectile = obj.get_child(9).get_child(0).variable
			obj.unit.add_child(attack)
	return block
			),
			
		"gatling" = (func ():
	var blockScene = preload("res://scenes/Blocks/loop_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "gatling_shoot ("
	block.unit = Global.selectedUnit
	block.variable = preload("res://scenes/Blocks/Attacks/Gatling/gatling.tscn")
	block.bottomText = ")"
	block.test = func (obj):
		if obj.get_child(9).get_child_count() == 1 && "variable" in obj.get_child(9).get_child(0):
			var attack = obj.variable.instantiate()
			attack.unit = obj.unit
			attack.projectile = obj.get_child(9).get_child(0).variable
			obj.unit.add_child(attack)
	return block
			),
			
		"spread" = (func ():
	var blockScene = preload("res://scenes/Blocks/loop_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "spread_shoot ("
	block.unit = Global.selectedUnit
	block.variable = preload("res://scenes/Blocks/Attacks/Spread/spread.tscn")
	block.bottomText = ")"
	block.test = func (obj):
		if obj.get_child(9).get_child_count() == 1 && "variable" in obj.get_child(9).get_child(0):
			var attack = obj.variable.instantiate()
			attack.projectile = obj.get_child(9).get_child(0).variable
			obj.unit.add_child(attack)
	return block
			)
		},
		"projectile"= {
			"melee": (func ():
	var blockScene = preload("res://scenes/Blocks/action_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "\"melee\""
	block.variable = preload("res://scenes/Blocks/Projectiles/Melee/melee.tscn")
	block.location = "shop"
	return block
			),
			"ranged": (func ():
	var blockScene = preload("res://scenes/Blocks/action_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "\"ranged\""
	block.variable = preload("res://scenes/Blocks/Projectiles/Ranged/ranged.tscn")
	block.location = "shop"
	return block
			),
			"homing": (func ():
	var blockScene = preload("res://scenes/Blocks/action_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "\"homing\""
	block.variable = preload("res://scenes/Blocks/Projectiles/Homing/homing.tscn")
	block.location = "shop"
	return block
			),
			"spike": (func ():
	var blockScene = preload("res://scenes/Blocks/action_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "\"spike\""
	block.variable = preload("res://scenes/Blocks/Projectiles/Spike/spike.tscn")
	block.location = "shop"
	return block
			),
			"chain": (func ():
	var blockScene = preload("res://scenes/Blocks/action_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "\"chain\""
	block.variable = preload("res://scenes/Blocks/Projectiles/Chain/chain.tscn")
	block.location = "shop"
	return block
			),
			
			}
 	}
const BUG_SPRITE_DICTIONARY = {
	"meep": {
		"DR": preload("res://Assets/Bugs/meep.png"),
		"DL": preload("res://Assets/Bugs/meep.png"),
		"UL": preload("res://Assets/Bugs/meep.png"),
		"UR": preload("res://Assets/Bugs/meep.png")},
	"fob": {
		"DR": preload("res://Assets/Bugs/meep.png"),
		"DL": preload("res://Assets/Bugs/meep.png"),
		"UL": preload("res://Assets/Bugs/meep.png"),
		"UR": preload("res://Assets/Bugs/meep.png")},
	"borf": {
		"DR": preload("res://Assets/Bugs/bug_basic.png"),
		"DL": preload("res://Assets/Bugs/bug_basic.png"),
		"UL": preload("res://Assets/Bugs/bug_basic.png"),
		"UR": preload("res://Assets/Bugs/bug_basic.png")},
	"spoid": {
		"DR": preload("res://Assets/Bugs/bug_basic.png"),
		"DL": preload("res://Assets/Bugs/bug_basic.png"),
		"UL": preload("res://Assets/Bugs/bug_basic.png"),
		"UR": preload("res://Assets/Bugs/bug_basic.png")},
	"tiny_spoid": {
		"DR": preload("res://Assets/Bugs/bug_basic.png"),
		"DL": preload("res://Assets/Bugs/bug_basic.png"),
		"UL": preload("res://Assets/Bugs/bug_basic.png"),
		"UR": preload("res://Assets/Bugs/bug_basic.png")},
	"bleep": {
		"DR": preload("res://Assets/Bugs/bug_basic.png"),
		"DL": preload("res://Assets/Bugs/bug_basic.png"),
		"UL": preload("res://Assets/Bugs/bug_basic.png"),
		"UR": preload("res://Assets/Bugs/bug_basic.png")},
	"zonk": {
		"DR": preload("res://Assets/Bugs/zonk.png"),
		"DL": preload("res://Assets/Bugs/zonk.png"),
		"UL": preload("res://Assets/Bugs/zonk.png"),
		"UR": preload("res://Assets/Bugs/zonk.png")},
	"lez_tail": {
		"DR": preload("res://Assets/Bugs/bug_basic.png"),
		"DL": preload("res://Assets/Bugs/bug_basic.png"),
		"UL": preload("res://Assets/Bugs/bug_basic.png"),
		"UR": preload("res://Assets/Bugs/bug_basic.png")},
	"lez_middle": {
		"DR": preload("res://Assets/Bugs/bug_basic.png"),
		"DL": preload("res://Assets/Bugs/bug_basic.png"),
		"UL": preload("res://Assets/Bugs/bug_basic.png"),
		"UR": preload("res://Assets/Bugs/bug_basic.png")},
	"lez_head": {
		"DR": preload("res://Assets/Bugs/bug_basic.png"),
		"DL": preload("res://Assets/Bugs/bug_basic.png"),
		"UL": preload("res://Assets/Bugs/bug_basic.png"),
		"UR": preload("res://Assets/Bugs/bug_basic.png")},
	"smorg": {
		"DR": preload("res://Assets/Bugs/bug_basic.png"),
		"DL": preload("res://Assets/Bugs/bug_basic.png"),
		"UL": preload("res://Assets/Bugs/bug_basic.png"),
		"UR": preload("res://Assets/Bugs/bug_basic.png")},
}
