extends Node2D
var bought = false
var up = false
var block
func _on_button_button_down() -> void:
	if !bought:
		Global.inventory.append(block)
	bought = true
	pass # Replace with function body.
	
func gen_rand(dict):
	randomize()
	var choose = randf_range(0.0, 1.0)
	
	var wt = 0.0
	for key in dict.keys():
		if key == null:
			continue
		if (choose >= wt && choose < wt + dict[key]):
			return key
		wt += dict[key]
	return dict.keys().back()

var a = ["basic", "radial", "gatling", "spread"]
func _ready() -> void:
	var blockType = gen_rand(Global.blockTypeWeights)
	var blockName
	if blockType == "attack":
		blockName = gen_rand(Global.attackWeights)
	elif blockType == "projectile":
		blockName = gen_rand(Global.projectileWeights)
	elif blockType == "augment":
		blockName = gen_rand(Global.augmentWeights)
	block = Global.BLOCKS_DICTIONARY[blockType][blockName].call()
	block.scale = Vector2(1.0, 1.0)
	if block.type == "loop":
		block.position = Vector2(10.0, 40.0)
	else:
		block.position = Vector2(10.0, 50.0)
	print(block)
	$Button.add_child(block)
	
func _process(delta: float) -> void:
	if bought:
		if !up:
			scale = lerp(scale, Vector2(1.2, 1.2), delta * 8)
		else:
			scale = lerp(scale, Vector2(0, 0), delta * 8)
			
		if scale > Vector2(1.16, 1.16):
			up = true
	
