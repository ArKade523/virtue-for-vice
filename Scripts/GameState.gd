extends Node

# const player stats
const MAX_HEALTH = 100
const BASE_DAMAGE = 10
const MOVEMENT_SPEED = 100.0

## Player TEAL
#stats
var teal_health: float = MAX_HEALTH
var teal_damage: float = BASE_DAMAGE
var teal_is_alive = true
var teal_attributes = ["handsome","dashing","considerate","good-personality","short-nose-hairs", "trimmed-toenails"]
# state
var teal_current_attacking = false

## Player BLUE
#player blue stats
var blue_health: float = MAX_HEALTH
var blue_damage: float = BASE_DAMAGE
var blue_is_alive = true
var blue_attributes = ["handsome","dashing","considerate","good-personality","short-nose-hairs", "trimmed-toenails"]
# state
var blue_current_attacking = false

## Other
const FIREBOLT_DAMAGE = 15

var next_dungeon_map = [
	{"scene": "res://Scenes/start_screen.tscn", "visibleHud": false }, 
	{"scene": "res://Scenes/story.tscn", "visibleHud": false }, 
	{"scene": "res://Scenes/dungeon1.tscn", "visibleHud": true }, 
	{"scene": "res://Scenes/level1end.tscn", "visibleHud": false }, 
	{"scene": "res://Scenes/dungeon2.tscn", "visibleHud": true }, 
	{"scene": "res://Scenes/level2end.tscn", "visibleHud": false }, 
	{"scene": "res://Scenes/dungeon3.tscn", "visibleHud": true }, 
	{"scene": "res://Scenes/victory.tscn", "visibleHud": false }, 
]
	
func _process(_delta: float) -> void:
	var teal_health_bar = get_tree().get_first_node_in_group("teal_health")
	var blue_health_bar = get_tree().get_first_node_in_group("blue_health")
	if (teal_health_bar and blue_health_bar):
		teal_health_bar.value = float(teal_health / MAX_HEALTH) * 100
		blue_health_bar.value = float(blue_health / (MAX_HEALTH)) * 100
