@tool
class_name Cylinder
extends Node2D


const BlockActor = preload("res://actors/block.tscn")


@export var x: int = 0:
	set(value):
		print("柱面x坐标发生变化：%d -> %d" % [x, value])
		x = value

@export var y: int = 0:
	set(value):
		print("柱面y坐标发生变化：%d -> %d" % [x, value])
		x = value

@export_range(0, 10, 1, "suffix:格") var height: int = 1:
	set(value):
		print("柱面高度发生变化：%d -> %d" % [height, value])
		height = value

@export var light: Block.LightType = Block.LightType.None:
	set(value):
		print("灯状态发生变化：%d -> %d" % [light, value])
		light = value


# Called when the node enters the scene tree for the first time.
func _ready():
	update()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		update()
	pass


func get_block_name(level: int) -> String:
	return "level_%d" % level


func get_block(level: int) -> Block:
	var name = get_block_name(level)
	var block = get_node(name)
	return block


func create_block(level: int) -> Block:
	var name = get_block_name(level)
	var block = BlockActor.instantiate()
	block.level = level
	block.name = name
	add_child(block)
	return block


func update():
	for level in height:
		var name = get_block_name(level)
		var top_level = level == height - 1
		var block: Block = null
		if has_node(name):
			block = get_block(level)
		else:
			block = create_block(level)
		
		if block == null:
			push_error("柱面%s无法找到节点：%s" % [self.name, name])
			return
		
		# TODO 更新方块其他状态
		
		if top_level:
			block.light_type = light
		else:
			block.light_type = Block.LightType.None
	
	pass
