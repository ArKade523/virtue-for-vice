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
