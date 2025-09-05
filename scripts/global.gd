extends Node

var player: Player
var game: Game

#func deep_copy_resource(res: Resource) -> Resource:
	#if res == null:
		#return null
	#var copy = res.duplicate()  # 基本属性先复制
	#for property in res.get_property_list():
		#var name = property.name
		#var value = res.get(name)
		#if value is Resource:
			#copy.set(name, deep_copy_resource(value))
		#elif typeof(value) == TYPE_ARRAY:
			#var new_array = []
			#for v in value:
				#if v is Resource:
					#new_array.append(deep_copy_resource(v))
				#else:
					#new_array.append(v)
			#copy.set(name, new_array)
		#elif typeof(value) == TYPE_DICTIONARY:
			#var new_dict = {}
			#for k in value.keys():
				#var v = value[k]
				#if v is Resource:
					#new_dict[k] = deep_copy_resource(v)
				#else:
					#new_dict[k] = v
			#copy.set(name, new_dict)
	#return copy
