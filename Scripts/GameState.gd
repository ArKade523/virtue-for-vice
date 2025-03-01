extends Node

#const player stats
const MAX_HEALTH = 100
const BASE_DAMAGE = 10
const MOVEMENT_SPEED = 100.0
#player teal stats
var teal_health = MAX_HEALTH
var teal_damage = BASE_DAMAGE
var teal_is_alive = true
var teal_attributes = ["handsome","dashing","considerate","good-personality","short-nose-hairs", "trimmed-toenails"]
#player blue stats
var blue_health = MAX_HEALTH
var blue_damage = BASE_DAMAGE
var blue_is_alive = true
var blue_attributes = ["handsome","dashing","considerate","good-personality","short-nose-hairs", "trimmed-toenails"]


var next_dungeon_map = {
	"dungeon1": "res://Scenes/dungeon2.tscn",
	"dungeon2": "res://Scenes/dungeon1.tscn",
}

func get_next_level(current_level: String) -> PackedScene:
	if next_dungeon_map.has(current_level):
		return load(next_dungeon_map[current_level])  # Load the next level scene
	return null  # No next level (end of game)
