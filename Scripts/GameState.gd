extends Node

#const player stats
const MAX_HEALTH = 100
const BASE_DAMAGE = 10
const MOVEMENT_SPEED = 100.0

##Player TEAL
#stats
var teal_health: float = MAX_HEALTH
var teal_damage: float = BASE_DAMAGE
var teal_is_alive = true
var teal_attributes = ["handsome","dashing","considerate","good-personality","short-nose-hairs", "trimmed-toenails"]
#state
var teal_current_attacking = false

##Player BLUE
#player blue stats
var blue_health = MAX_HEALTH
var blue_damage = BASE_DAMAGE
var blue_is_alive = true
var blue_attributes = ["handsome","dashing","considerate","good-personality","short-nose-hairs", "trimmed-toenails"]
#state
var blue_current_attacking = false

##Other
const FIREBOLT_DAMAGE = 15

var next_dungeon_map = [
	"res://Scenes/start_screen.tscn",
	"res://Scenes/dungeon1.tscn",
	"res://Scenes/dungeon2.tscn",
	"res://Scenes/dungeon3.tscn",
	"res://Scenes/dungeon1.tscn",
]



var current_scene_container: Node2D
var current_scene: int = 0





func _ready():
	current_scene_container = get_tree().get_first_node_in_group("current_area")
	load_next_level()
	
func _process(_delta: float) -> void:
	var teal_health_bar = get_tree().get_first_node_in_group("teal_health")
	var blue_health_bar = get_tree().get_first_node_in_group("blue_health")
	if (teal_health_bar and blue_health_bar):
		teal_health_bar.value = float(teal_health / MAX_HEALTH) * 100
		blue_health_bar.value = float(blue_health / MAX_HEALTH) * 100

func load_next_level():
	if next_dungeon_map[current_scene]:
		var next_scene = load(next_dungeon_map[current_scene]) as PackedScene
		if !next_scene:
			return
		if (!current_scene_container):
			current_scene_container = get_tree().get_first_node_in_group("current_area")
		for child in current_scene_container.get_children():
			child.queue_free()
			await child.tree_exited
		
		var instance = next_scene.instantiate()
		current_scene_container.add_child(instance)
		current_scene += 1
