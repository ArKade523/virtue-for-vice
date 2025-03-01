extends Node

#general player stats
const max_health = 100
const base_damage = 10

#player teal stats
var teal_health = max_health
var teal_damage = base_damage
var teal_attributes = ["handsome","dashing","considerate","good-personality","short-nose-hairs", "trimmed-toenails"]

#blue player stats
var blue_health = max_health
var blue_damage = base_damage
var blue_attributes = ["handsome","dashing","considerate","good-personality","short-nose-hairs", "trimmed-toenails"]

var next_dungeon_map = {
	"dungeon1": "res://Scenes/dungeon2.tscn",
	"dungeon2": "res://Scenes/dungeon1.tscn",
}

func get_next_level(current_level: String) -> PackedScene:
	if next_dungeon_map.has(current_level):
		return load(next_dungeon_map[current_level])  # Load the next level scene
	return null  # No next level (end of game)
