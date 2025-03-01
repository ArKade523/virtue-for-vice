extends Node

var next_dungeon_map = {
	"dungeon1": "res://Scenes/dungeon2.tscn",
	"dungeon2": "res://Scenes/dungeon1.tscn",
}

func get_next_level(current_level: String) -> PackedScene:
	if next_dungeon_map.has(current_level):
		return load(next_dungeon_map[current_level])  # Load the next level scene
	return null  # No next level (end of game)
