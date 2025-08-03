extends Node

var cursorGrab = false
var inventory = []
var editor
var disableMouse = false

var unitBaseCost = 50
var bits = 75

var timeScale = 1.0

var currBlock;

var selectedUnit
var selectedBlock
var unitScripts = {
}

var path_node
var battlefield
var grid

var computer_terminal_style_box = load("res://Scenes/Main/Field/computer.tres")
var computer_terminal # the node that is the computer terminal

var wave
#region dmg
var baseDmg = {
	"melee": 20.0,
	"ranged": 5.0,
	"homing": 5.0,
	"spike": 3.0,
	"chain": 10.0
}

var shopBase = {
	"upgrade": 50.0,
	"unit": 20.0,
	"reroll": 5.0,
	"basic": 10.0,
	"radial": 20.0,
	"gatling": 25.0,
	"spread": 15.0,
	"melee": 10.0,
	"ranged": 10.0,
	"chain": 15.0,
	"homing": 15.0,
	"spike": 20.0,
	"slow": 20,
	"pierce": 20,
	"burn": 25,
	"poison": 25,
	"ice":  25,
	"big": 20,
	"explode": 30,
	"projectile": 20
}

var shopScales = {
	"upgrade": 1.0,
	"unit": 1.0,
	"reroll": 1.0,
	"shop": 1.0,
}

#region Weights
var blockTypeWeights = {
	"attack": 0.5,
	"projectile": 0.25,
	"augment": 0.25
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

var augmentWeights = {
	"poison" = 1.0 / 7.0,
	"slow" = 1.0 / 7.0,
	"burn" = 1.0 / 7.0,
	"ice" = 1.0 / 7.0,
	"big" = 1.0 / 7.0,
	"explode" = 1.0 / 7.0,
	"projectile" = 1.0 / 7.0
}
#endregion spawning weights

#region BLOCKS

var BLOCKS_DICTIONARY = {
	"attack" = {
		"basic" = (func ():
	var blockScene = preload("res://scenes/Blocks/loop_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "basic_shoo ("
	block.unit =Global.selectedUnit
	block.variable = preload("res://scenes/Blocks/Attacks/Basic/basic.tscn")
	block.bottomText = ")"
	block.holeType = 0
	block.nubType1 = 1
	block.nubType2 = 0
	block.setColor(Color("ef89e4"), block)
	block.test = func (obj):
		if obj.get_child(8).get_child_count() == 1 && "variable" in obj.get_child(8).get_child(0):
			var attack = obj.variable.instantiate()
			attack.projectile = obj.get_child(8).get_child(0).variable
			attack.unit = obj.unit
			var attackBlock = obj.get_child(8).get_child(0)
			if attackBlock.get_child_count() == 7 && attackBlock.get_child(6) != null && attackBlock.get_child(6).typeOf == "augment":
				attack.augments = attackBlock.get_child(6).augments
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
	block.holeType = 0
	block.nubType1 = 1
	block.nubType2 = 0
	block.setColor(Color("ef89e4"), block)
	block.test = func (obj):
		if obj.get_child(8).get_child_count() == 1 && "variable" in obj.get_child(8).get_child(0):
			var attack = obj.variable.instantiate()
			attack.unit = obj.unit
			attack.projectile = obj.get_child(8).get_child(0).variable
			var attackBlock = obj.get_child(8).get_child(0)
			if attackBlock.get_child_count() == 7 && attackBlock.get_child(6) != null && attackBlock.get_child(6).typeOf == "augment":
				attack.augments = attackBlock.get_child(6).augments
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
	block.holeType = 0
	block.nubType1 = 1
	block.nubType2 = 0
	block.setColor(Color("ef89e4"), block)
	block.test = func (obj):
		if obj.get_child(8).get_child_count() == 1 && "variable" in obj.get_child(8).get_child(0):
			var attack = obj.variable.instantiate()
			attack.unit = obj.unit
			attack.projectile = obj.get_child(8).get_child(0).variable
			var attackBlock = obj.get_child(8).get_child(0)
			if attackBlock.get_child_count() == 7 && attackBlock.get_child(6) != null && attackBlock.get_child(6).typeOf == "augment":
				attack.augments = attackBlock.get_child(6).augments
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
	block.holeType = 0
	block.nubType1 = 1
	block.nubType2 = 0
	block.setColor(Color("ef89e4"), block)
	block.test = func (obj):
		if obj.get_child(8).get_child_count() == 1 && "variable" in obj.get_child(8).get_child(0):
			var attack = obj.variable.instantiate()
			attack.unit = obj.unit
			attack.projectile = obj.get_child(8).get_child(0).variable
			var attackBlock = obj.get_child(8).get_child(0)
			if attackBlock.get_child_count() == 7 && attackBlock.get_child(6) != null && attackBlock.get_child(6).typeOf == "augment":
				attack.augments = attackBlock.get_child(6).augments
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
	#1fcadc
	block.setColor(Color("1fcadc"), block)
	block.holeType = 1
	block.nubType = 2
	return block
			),
			"ranged": (func ():
	var blockScene = preload("res://scenes/Blocks/action_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "\"ranged\""
	block.variable = preload("res://scenes/Blocks/Projectiles/Ranged/ranged.tscn")
	block.location = "shop"
	block.holeType = 1
	block.setColor(Color("1fcadc"), block)
	block.nubType = 2
	return block
			),
			"homing": (func ():
	var blockScene = preload("res://scenes/Blocks/action_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "\"homing\""
	block.variable = preload("res://scenes/Blocks/Projectiles/Homing/homing.tscn")
	block.location = "shop"
	block.holeType = 1
	block.setColor(Color("1fcadc"), block)
	block.nubType = 2
	return block
			),
			"spike": (func ():
	var blockScene = preload("res://scenes/Blocks/action_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "\"spike\""
	block.variable = preload("res://scenes/Blocks/Projectiles/Spike/spike.tscn")
	block.location = "shop"
	block.holeType = 1
	block.nubType = 2
	block.setColor(Color("1fcadc"), block)
	return block
			),
			"chain": (func ():
	var blockScene = preload("res://scenes/Blocks/action_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "\"chain\""
	block.variable = preload("res://scenes/Blocks/Projectiles/Chain/chain.tscn")
	block.location = "shop"
	block.holeType = 1
	block.setColor(Color("1fcadc"), block)
	block.nubType = 2
	return block
			),
			
			},
			"augment" = {
				"slow": (func ():
	var blockScene = preload("res://scenes/Blocks/action_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "\"slow\""
	block.variable = ["slow"]
	block.location = "shop"
	block.typeOf = "augment"
	block.setColor(Color("b5bc56"), block)
	block.holeType = 2
	block.nubType = 2
	return block
			),
			"pierce": (func ():
	var blockScene = preload("res://scenes/Blocks/action_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "\"pierce\""
	block.variable = ["pierce"]
	block.location = "shop"
	block.typeOf = "augment"
	block.setColor(Color("b5bc56"), block)
	block.holeType = 2
	block.nubType = 2
	return block
			),
			"burn": (func ():
	var blockScene = preload("res://scenes/Blocks/action_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "\"burn\""
	block.variable = ["fire"]
	block.location = "shop"
	block.typeOf = "augment"
	block.holeType = 2
	block.setColor(Color("b5bc56"), block)
	block.nubType = 2
	return block
			),
			"poison": (func ():
	var blockScene = preload("res://scenes/Blocks/action_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "\"poison\""
	block.variable = ["poison"]
	block.typeOf = "augment"
	block.location = "shop"
	block.holeType = 2
	block.nubType = 2
	block.setColor(Color("b5bc56"), block)
	return block
			),
			"ice": (func ():
	var blockScene = preload("res://scenes/Blocks/action_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "\"ice\""
	block.variable = ["ice"]
	block.typeOf = "augment"
	block.location = "shop"
	block.holeType = 2
	block.nubType = 2
	block.setColor(Color("b5bc56"), block)
	return block
			),
			"big": (func ():
	var blockScene = preload("res://scenes/Blocks/action_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "\"big\""
	block.variable = ["big"]
	block.typeOf = "augment"
	block.location = "shop"
	block.holeType = 2
	block.nubType = 2
	block.setColor(Color("b5bc56"), block)
	return block
			),
			"explode": (func ():
	var blockScene = preload("res://scenes/Blocks/action_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "\"explode\""
	block.variable = ["explode"]
	block.typeOf = "augment"
	block.location = "shop"
	block.holeType = 2
	block.nubType = 2
	block.setColor(Color("b5bc56"), block)
	return block
			),
			"projectile": (func ():
	var blockScene = preload("res://scenes/Blocks/action_block.tscn")
	var block = blockScene.instantiate()
	block.functionName = "\"projectile\""
	block.variable = ["projectile"]
	block.typeOf = "augment"
	block.location = "shop"
	block.holeType = 2
	block.nubType = 2
	block.setColor(Color("b5bc56"), block)
	return block
			)
			}
	}
#endregion blocks

#to be used for sprite sheets
#const BUG_SPRITE_DICTIONARY = {
	#"meep": {
		#"DR": "down_right",
		#"DL": "down_left",
		#"UL": "up_left",
		#"UR": "up_right"},
	#"fob": {
		#"DR": "down_right",
		#"DL": "down_left",
		#"UL": "up_left",
		#"UR": "up_right"},
	#"borf": {
		#"DR": "down_right",
		#"DL": "down_left",
		#"UL": "up_left",
		#"UR": "up_right"},
	#"spoid": {
		#"DR": "down_right",
		#"DL": "down_left",
		#"UL": "up_left",
		#"UR": "up_right"},
	#"tini_spoid": {
		#"DR": "down_right",
		#"DL": "down_left",
		#"UL": "up_left",
		#"UR": "up_right"},
	#"bleep": {
		#"DR": "down_right",
		#"DL": "down_left",
		#"UL": "up_left",
		#"UR": "up_right"},
	#"zonk": {
		#"DR": "down_right",
		#"DL": "down_left",
		#"UL": "up_left",
		#"UR": "up_right"},
	#"lezzz_tail": {
		#"DR": "down_right",
		#"DL": "down_left",
		#"UL": "up_left",
		#"UR": "up_right"},
	#"lezzz_middle": {
		#"DR": "down_right",
		#"DL": "down_left",
		#"UL": "up_left",
		#"UR": "up_right"},
	#"lezzz_head": {
		#"DR": "down_right",
		#"DL": "down_left",
		#"UL": "up_left",
		#"UR": "up_right"},
	#"smorg": {
		#"DR": "down_right",
		#"DL": "down_left",
		#"UL": "up_left",
		#"UR": "up_right"},
#}

# keep for now
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
	"tini_spoid": {
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
	"lezzz_tail": {
		"DR": preload("res://Assets/Bugs/bug_basic.png"),
		"DL": preload("res://Assets/Bugs/bug_basic.png"),
		"UL": preload("res://Assets/Bugs/bug_basic.png"),
		"UR": preload("res://Assets/Bugs/bug_basic.png")},
	"lezzz_middle": {
		"DR": preload("res://Assets/Bugs/lez/Lez Middle/LEZZZ_MID_SAMPLE.webp"),
		"DL": preload("res://Assets/Bugs/lez/Lez Middle/LEZZZ_MID_BACK_SAMPLE.webp"),
		"UL": preload("res://Assets/Bugs/lez/Lez Middle/LEZZZ_MID_SAMPLE.webp"),
		"UR": preload("res://Assets/Bugs/lez/Lez Middle/LEZZZ_MID_BACK_SAMPLE.webp")},
	"lezzz_head": {
		"DR": preload("res://Assets/Bugs/bug_basic.png"),
		"DL": preload("res://Assets/Bugs/bug_basic.png"),
		"UL": preload("res://Assets/Bugs/bug_basic.png"),
		"UR": preload("res://Assets/Bugs/bug_basic.png")},
	"smorg": {
		"DR": preload("res://Assets/Bugs/Smorg/SMORG_SAMPLE.webp"),
		"DL": preload("res://Assets/Bugs/Smorg/SMORG_SAMPLE.webp"),
		"UL": preload("res://Assets/Bugs/Smorg/SMORG_SAMPLE.webp"),
		"UR": preload("res://Assets/Bugs/Smorg/SMORG_SAMPLE.webp")},
}

const BUG_STAT_DICTIONARY = {
	"meep": {
		"health": 50,
		"value": 2,
		"speed": 1.578,
		"damage": 3,
		},
	"fob": {
		"health": 30,
		"value": 1,
		"speed": 3.5,
		"damage": 1,
		},
	"borf": {
		"health": 200,
		"value": 5,
		"speed": 1,
		"damage": 10,
		},
	"spoid": {
		"health": 80,
		"value": 2,
		"speed": 1.276,
		"damage": 4,
		},
	"tini_spoid": {
		"health": 40,
		"value":  1,
		"speed":  3.578,
		"damage":  4,
		},
	"bleep": 
		{
		"health": 65,
		"value": 8,
		"speed": 2.11,
		"damage": 4,
		},
	"zonk": {
		"health": 25,
		"value": 10,
		"speed": 5.8,
		"damage": 30,
		},
	#region lez stats
	"lezzz_tail": {
		"health": 100,
		"value": .5,
		"speed": 1.578,
		"damage": .25,
		},
	"lezzz_middle": {
		"health": 100,
		"value": .5,
		"speed": 1.578,
		"damage": .25,
		},
	"lezzz_head": {
		"health": 100,
		"value": .5,
		"speed": 1.578,
		"damage": .25,
		},
		#endregion lez stats
	"smorg": {
		"health": 5000,
		"value": 50,
		"speed": .5,
		"damage": 35,
	}
}
