@tool
class_name Block
extends Node2D


const horizontal_angle = 45

enum LightType {
	None,
	Off,
	On,
}

const LightOffColor: Color = Color(0.4, 0.4, 1)
const LightOnColor: Color = Color(1, 1, 0)


# 顶面类型
@export var light_type: LightType = LightType.None:
	set(value):
		# print("灯状态变化%f -> %f" % [light_type, value])
		light_type = value

# 俯视角状态
@export_range(5, 85, 0.01, "suffix:角度") var vertical_angle: float = 45:
	set(value):
		# print("俯视角发生变化%f -> %f" % [vertical_angle, value])
		vertical_angle = value

# 顶面边长
@export var top_size: float = 64:
	set(value):
		# print("顶面边长发生变化%f -> %f" % [top_size, value])
		top_size = value

# 方块高度
@export var height: float = 48:
	set(value):
		# print("方块高度发生变化%f -> %f" % [height, value])
		height = value

# 方块颜色
@export var color: Color = Color(0.5, 0.5, 0.5):
	set(value):
		# print("方块颜色发生变化%s -> %s" % [color, value])
		color = value

# 棱线颜色
@export var border_color: Color = Color(0.25, 0.25, 0.25):
	set(value):
		# print("棱线颜色发生变化%s -> %s" % [border_color, value])
		border_color = value

# 棱线粗细
@export var border_width: float = 1:
	set(value):
		# print("棱线粗细发生变化%f -> %f" % [border_width, value])
		border_width = value

# 层级
@export_range(0, 10, 1, "suffix:格") var level: int = 0:
	set(value):
		# print("层级发生变化 %d -> %d" % [level, value])
		level = value


# 半俯视弧度（用于计算顶面三角高度）
var top_angle: float:
	get:
		return deg_to_rad(vertical_angle / 2)

# 顶面对角线长度
var diagonal_length: float:
	get:
		return top_size * sqrt(2)

# 顶面高度
var top_height: float:
	get:
		return (diagonal_length / 2) * tan(top_angle)

# 上顶点
var top: Vector2:
	get:
		return Vector2(0, -top_height)

# 中顶点
var middle: Vector2:
	get:
		return Vector2(0, top_height)

# 左上顶点
var top_left: Vector2:
	get:
		return Vector2(-diagonal_length / 2, 0)

# 右上顶点
var top_right: Vector2:
	get:
		return Vector2(diagonal_length / 2, 0)

var bottom_left: Vector2:
	get:
		return Vector2(-diagonal_length / 2, height)

var bottom_right: Vector2:
	get:
		return Vector2(diagonal_length / 2, height)

var bottom: Vector2:
	get:
		return Vector2(0, top_height + height)

var top_colors: PackedColorArray:
	get:
		var color = self.color
		match light_type:
			LightType.Off: color = LightOffColor
			LightType.On: color = LightOnColor
		return PackedColorArray([color])

# 方块颜色（用于绘制多边形）
var colors: PackedColorArray:
	get:
		return PackedColorArray([color])

# 棱线颜色（用于绘制多边形）
var border_colors: PackedColorArray:
	get:
		return PackedColorArray([border_color])
	

func _ready():
	queue_redraw()
	pass


func _process(delta):
	if Engine.is_editor_hint():
		update()
	pass


func _draw():
	draw_polygon(PackedVector2Array([
		top, top_right, middle, top_left
	]), top_colors)
	
	draw_polygon(PackedVector2Array([
		middle, top_left, bottom_left, bottom, bottom_right, top_right
	]), colors)
	
	draw_line(
		top, top_left, border_color, border_width,
	)
	draw_line(
		top, top_right, border_color, border_width,
	)
	draw_line(
		middle, top_left, border_color, border_width,
	)
	draw_line(
		middle, top_right, border_color, border_width,
	)
	draw_line(
		middle, bottom, border_color, border_width,
	)
	draw_line(
		bottom_left, bottom, border_color, border_width,
	)
	draw_line(
		bottom_left, top_left, border_color, border_width,
	)
	draw_line(
		bottom_right, bottom, border_color, border_width,
	)
	draw_line(
		bottom_right, top_right, border_color, border_width,
	)


func update():
	position.y = level * -height
	queue_redraw()
