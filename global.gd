extends Node

var cursorGrab = false
var inventory = []
var editor
var disableMouse = false

var unitBaseCost = 50
var bits = 150

var timeScale = 1.0

var currBlock;

var selectedUnit
var selectedBlock
var unitScripts = {
}

var path_node
var battlefield
var grid

var hit_sfx

var computer_terminal_style_box = load("res://Scenes/Main/Field/computer.tres")
var computer_terminal # the node that is the computer terminal

var wave
#region dmg
var baseDmg = {
	"melee": 20.0,
	"ranged": 18.0,
	"homing": 12.0,
	"spike": 3.5,
	"chain": 7,
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

#var attackWeights = {
	#"basic": 0.25,
	#"radial": 0.25,
	#"gatling": 0.25,
	#"spread": 0.25
#}

var attackWeights = {
	"basic": 0.33,
	"radial": 0.34,
	"spread": 0.33
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
	block.functionName = "basic_shoot ("
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
			attack.delay = obj.unit.delay
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
			attack.delay = obj.unit.delay
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
			attack.delay = obj.unit.delay
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
			attack.delay = obj.unit.delay
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
const BUG_SPRITE_DICTIONARY = {
	"meep": {
		"DR": "meep_down_right",
		"DL": "meep_down_left",
		"UL": "meep_up_left",
		"UR": "meep_up_right"},
	"fob": {
		"DR": "fob_down_right",
		"DL": "fob_down_left",
		"UL": "fob_up_left",
		"UR": "fob_up_right"},
	"borf": {
		"DR": "borf_down_right",
		"DL": "borf_down_left",
		"UL": "borf_up_left",
		"UR": "borf_up_right"},
	"spoid": {
		"DR": "spoid_down_right",
		"DL": "spoid_down_left",
		"UL": "spoid_up_left",
		"UR": "spoid_up_right"},
	"tini_spoid": {
		"DR": "tini_spoid_down_right",
		"DL": "tini_spoid_down_left",
		"UL": "tini_spoid_up_left",
		"UR": "tini_spoid_up_right"},
	"bleep": {
		"DR": "bleep_down_right",
		"DL": "bleep_down_left",
		"UL": "bleep_up_left",
		"UR": "bleep_up_right"},
	"zonk": {
		"DR": "zonk_down_right",
		"DL": "zonk_down_left",
		"UL": "zonk_up_left",
		"UR": "zonk_up_right"},
	"lezzz_tail": {
		"DR": "lezzz_tail_down_right",
		"DL": "lezzz_tail_down_left",
		"UL": "lezzz_tail_up_left",
		"UR": "lezzz_tail_up_right"},
	"lezzz_middle": {
		"DR": "lezzz_middle_down_right",
		"DL": "lezzz_middle_down_left",
		"UL": "lezzz_middle_up_left",
		"UR": "lezzz_middle_up_right"},
	"lezzz_head": {
		"DR": "lezzz_head_down_right",
		"DL": "lezzz_head_down_left",
		"UL": "lezzz_head_up_left",
		"UR": "lezzz_head_up_right"},
	"smorg": {
		"DR": "smorg_down_right",
		"DL": "smorg_down_left",
		"UL": "smorg_up_left",
		"UR": "smorg_up_right"},
}

# keep for now
#const BUG_SPRITE_DICTIONARY = {
	#"meep": {
		#"DR": preload("res://Assets/Bugs/meep.png"),
		#"DL": preload("res://Assets/Bugs/meep.png"),
		#"UL": preload("res://Assets/Bugs/meep.png"),
		#"UR": preload("res://Assets/Bugs/meep.png")},
	#"fob": {
		#"DR": preload("res://Assets/Bugs/meep.png"),
		#"DL": preload("res://Assets/Bugs/meep.png"),
		#"UL": preload("res://Assets/Bugs/meep.png"),
		#"UR": preload("res://Assets/Bugs/meep.png")},
	#"borf": {
		#"DR": preload("res://Assets/Bugs/bug_basic.png"),
		#"DL": preload("res://Assets/Bugs/bug_basic.png"),
		#"UL": preload("res://Assets/Bugs/bug_basic.png"),
		#"UR": preload("res://Assets/Bugs/bug_basic.png")},
	#"spoid": {
		#"DR": preload("res://Assets/Bugs/bug_basic.png"),
		#"DL": preload("res://Assets/Bugs/bug_basic.png"),
		#"UL": preload("res://Assets/Bugs/bug_basic.png"),
		#"UR": preload("res://Assets/Bugs/bug_basic.png")},
	#"tini_spoid": {
		#"DR": preload("res://Assets/Bugs/bug_basic.png"),
		#"DL": preload("res://Assets/Bugs/bug_basic.png"),
		#"UL": preload("res://Assets/Bugs/bug_basic.png"),
		#"UR": preload("res://Assets/Bugs/bug_basic.png")},
	#"bleep": {
		#"DR": preload("res://Assets/Bugs/bug_basic.png"),
		#"DL": preload("res://Assets/Bugs/bug_basic.png"),
		#"UL": preload("res://Assets/Bugs/bug_basic.png"),
		#"UR": preload("res://Assets/Bugs/bug_basic.png")},
	#"zonk": {
		#"DR": preload("res://Assets/Bugs/zonk.png"),
		#"DL": preload("res://Assets/Bugs/zonk.png"),
		#"UL": preload("res://Assets/Bugs/zonk.png"),
		#"UR": preload("res://Assets/Bugs/zonk.png")},
	#"lezzz_tail": {
		#"DR": preload("res://Assets/Bugs/bug_basic.png"),
		#"DL": preload("res://Assets/Bugs/bug_basic.png"),
		#"UL": preload("res://Assets/Bugs/bug_basic.png"),
		#"UR": preload("res://Assets/Bugs/bug_basic.png")},
	#"lezzz_middle": {
		#"DR": preload("res://Assets/Bugs/lez/Lez Middle/LEZZZ_MID_SAMPLE.webp"),
		#"DL": preload("res://Assets/Bugs/lez/Lez Middle/LEZZZ_MID_BACK_SAMPLE.webp"),
		#"UL": preload("res://Assets/Bugs/lez/Lez Middle/LEZZZ_MID_SAMPLE.webp"),
		#"UR": preload("res://Assets/Bugs/lez/Lez Middle/LEZZZ_MID_BACK_SAMPLE.webp")},
	#"lezzz_head": {
		#"DR": preload("res://Assets/Bugs/bug_basic.png"),
		#"DL": preload("res://Assets/Bugs/bug_basic.png"),
		#"UL": preload("res://Assets/Bugs/bug_basic.png"),
		#"UR": preload("res://Assets/Bugs/bug_basic.png")},
	#"smorg": {
		#"DR": preload("res://Assets/Bugs/Smorg/SMORG_SAMPLE.webp"),
		#"DL": preload("res://Assets/Bugs/Smorg/SMORG_SAMPLE.webp"),
		#"UL": preload("res://Assets/Bugs/Smorg/SMORG_SAMPLE.webp"),
		#"UR": preload("res://Assets/Bugs/Smorg/SMORG_SAMPLE.webp")},
#}

const BUG_STAT_DICTIONARY = {
	"meep": {
		"health": 10,
		"value": 2,
		"speed": 1.578,
		"damage": 2,
		},
	"fob": {
		"health": 5,
		"value": 1,
		"speed": 2.5,
		"damage": 1,
		},
	"borf": {
		"health": 50,
		"value": 5,
		"speed": 1.0,
		"damage": 5,
		},
	"spoid": {
		"health": 120,
		"value": 4,
		"speed": 0.8,
		"damage": 4,
		},
	"tini_spoid": {
		"health": 10,
		"value":  3,
		"speed":  1.89,
		"damage":  4,
		},
	"bleep": 
		{
		"health": 75,
		"value": 7,
		"speed": 2.25,
		"damage": 4,
		},
	"zonk": {
		"health": 25,
		"value": 12,
		"speed": 3.5,
		"damage": 7,
		},
	#region lez stats
	"lezzz_tail": {
		"health": 50,
		"value": 2,
		"speed": 1.2,
		"damage": .75,
		},
	"lezzz_middle": {
		"health": 50,
		"value": 2,
		"speed": 1.2,
		"damage": .75,
		},
	"lezzz_head": {
		"health": 100,
		"value": 2,
		"speed": 1.2,
		"damage": .75,
		},
		#endregion lez stats
	"smorg": {
		"health": 2000,
		"value": 50,
		"speed": 0.5,
		"damage": 50,
	}
}
