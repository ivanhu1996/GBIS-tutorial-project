extends EquipmentData
class_name MyEquipmentData

@export var drop_model :PackedScene

@export_group("basic attribute")
## 物品名称，需要唯一
@export var Item_power: int = 60
## 物品类型，值为“ANY”表示所有类型
@export var Total_armor: int = 80

## 检测装备是否可用，需重写
func test_need(_slot_name: String) -> bool:
	return true

## 装备时调用，需重写；也可以使用 GBIS.sig_slot_item_equipped 信号行处理
func equipped(_slot_name: String) -> void:
	pass

## 脱装备时调用，需重写；也可以用 GBIS.sig_slot_item_unequipped 信号进行处理
func unequipped(_slot_name: String) -> void:
	pass

## 丢弃物品时调用，需重写
func drop() -> void:
	Global.game.throw_item(self)
