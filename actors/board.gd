@tool
class_name Board
extends Node2D

const BlockActor = preload("res://actors/block.tscn")

@export_group("面板")
@export var width: int = 1:
	set(value):
		print("面板宽度发生变化：%d -> %d" % [width, value])
		width = value

@export var height: int = 1:
	set(value):
		print("面板高度发生变化：%d -> %d" % [height, value])
		height = value

@export_group("柱面")
@export var datas: PackedByteArray = PackedByteArray():
	set(values):
		datas = values

@export_group("方块", "block_")
@export var block_top_size: float = 64:
	set(value):
		update()

@export var block_height: float = 48:
	set(value):
		update()


# Called when the node enters the scene tree for the first time.
func _ready():
	update()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_block_name(x: int, y: int, z: int) -> String:
	var name = "block_%d_%d_%d" % [x, y, z]
	return name


func get_block(x: int, y: int, z: int) -> Block:
	var name = get_block_name(x, y, z)
	var block = get_node(name)
	return block


func create_block(x: int, y: int, z: int, light: Block.LightType):
	var name = get_block_name(x, y, z)
	var block = BlockActor.instantiate()
	block.name = name
	block.offset_x = x
	block.offset_y = y
	add_child(block)


func get_data_index(x: int, y: int):
	return x + y * width


func update_block(x: int, y: int, z: int):
	var block = get_block(x, y, z)
	var index = get_data_index(x, y)
	var data = datas[index]
	var height = data % 10
	var light: Block.LightType = data / 10
	update_block_status(block, light)
	pass


func update_block_status(block: Block, light: Block.LightType):
	block.light_type = light
	block.update()
	pass


func update():
	var level_max = (width-1) + (height-1)
	var level = 0
	
	for start_y in height:
		print("正在更新图层 %d" % level)
		for x in range(level+1):
			var y = level - x
			print("正在更新柱面 (%d, %d)" % [x, y])
		level+=1
	
	for start_x in range(1, width):
		print("正在更新Level %d" % level)
		var end_x = level - start_x + 1
		for x in range(start_x, end_x):
			var y = level - x
			print("正在更新柱面 (%d, %d)" % [x, y])
		level+=1
	
	queue_redraw()
