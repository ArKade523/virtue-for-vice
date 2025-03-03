extends Node2D

@onready var pt = $PlayerTeal
@onready var pb = $PlayerBlue
@onready var current_scene_container: Node2D = $CurrentScene

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
	#{"scene": "res://Scenes/start_screen.tscn", "visibleHud": false }, 
	#{"scene": "res://Scenes/story.tscn", "visibleHud": false }, 
	{"scene": "res://Scenes/dungeon1.tscn", "visibleHud": true }, 
	{"scene": "res://Scenes/level1end.tscn", "visibleHud": false }, 
	{"scene": "res://Scenes/dungeon2.tscn", "visibleHud": true }, 
	{"scene": "res://Scenes/level2end.tscn", "visibleHud": false }, 
	{"scene": "res://Scenes/dungeon3.tscn", "visibleHud": true }, 
	{"scene": "res://Scenes/victory.tscn", "visibleHud": false }, 
]

func _ready():
	load_next_level()
	
func _process(_delta: float) -> void:
	var teal_health_bar = get_tree().get_first_node_in_group("teal_health")
	var blue_health_bar = get_tree().get_first_node_in_group("blue_health")
	if (teal_health_bar and blue_health_bar):
		teal_health_bar.value = float(teal_health / MAX_HEALTH) * 100
		blue_health_bar.value = float(blue_health / (MAX_HEALTH)) * 100

var current_scene_idx: int = 0

func load_next_level():
	var next_dungeon = next_dungeon_map[current_scene_idx]
	
	if next_dungeon:
		var next_scene = load(next_dungeon["scene"]) as PackedScene
		if !next_scene:
			return
		for child in current_scene_container.get_children():
			child.queue_free()
			await child.tree_exited
		
		var instance = next_scene.instantiate()
		current_scene_container.add_child(instance)
		current_scene_idx += 1
		toggleHudVisibility(next_dungeon["visibleHud"])
		movePlayersToStart()
			
func toggleHudVisibility(on: bool):
	var teal_health_bar = get_tree().get_first_node_in_group("teal_health")
	var blue_health_bar = get_tree().get_first_node_in_group("blue_health")
	pt.visible = on
	pb.visible = on
	if teal_health_bar:
		teal_health_bar.visible = on
	if blue_health_bar:
		blue_health_bar.visible = on
	
func movePlayersToStart():
	var ptstart = get_tree().get_first_node_in_group("player_teal_start")
	var pbstart = get_tree().get_first_node_in_group("player_blue_start")

	if not (pt and pb):  
		pt = $PlayerTeal
		pb = $PlayerBlue

	if not (pt and pb):
		print("Error: Players not found!")
		return  # Exit if players don't exist

	if not (ptstart and pbstart):
		print("Error: Player start positions not found!")
		return  # Exit if start positions are missing

	# Move players to their start positions
	pt.global_position = ptstart.global_position
	pb.global_position = pbstart.global_position
