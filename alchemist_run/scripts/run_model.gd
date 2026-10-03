extends RefCounted

signal event(kind, amount)
signal phase_changed
const Catalog = preload("res://scripts/catalog.gd")
const BOSS_TYPES = [2, 5, 9, 10, 11, 12, 13, 14, 15, 16, 17]
const ORDINARY_TYPES = [0, 1, 3, 4, 6, 7, 8]
const ENEMIES = [
	{"hp":70.0, "armor":8.0, "interval":4.5, "damage":12.0, "trait":"armor", "visual":0},
	{"hp":62.0, "armor":0.0, "interval":2.7, "damage":9.0, "trait":"fast", "visual":1},
	{"hp":195.0, "armor":7.0, "interval":3.8, "damage":15.0, "trait":"heal", "visual":2},
	{"hp":86.0, "armor":3.0, "interval":3.5, "damage":13.0, "trait":"reflect", "visual":3},
	{"hp":80.0, "armor":2.0, "interval":3.6, "damage":12.0, "trait":"poison", "visual":4},
	{"hp":240.0, "armor":18.0, "interval":3.1, "damage":18.0, "trait":"glass", "visual":5},
	{"hp":92.0, "armor":0.0, "interval":3.2, "damage":14.0, "trait":"drain", "visual":6},
	{"hp":74.0, "armor":0.0, "interval":2.2, "damage":11.0, "trait":"flash", "visual":7},
	{"hp":112.0, "armor":14.0, "interval":4.0, "damage":19.0, "trait":"heavy", "visual":8},
	{"hp":330.0, "armor":12.0, "interval":2.8, "damage":21.0, "trait":"final", "visual":9},
	{"hp":215.0, "armor":16.0, "interval":3.6, "damage":17.0, "trait":"bell", "visual":10},
	{"hp":225.0, "armor":6.0, "interval":3.3, "damage":16.0, "trait":"spores", "visual":11},
	{"hp":270.0, "armor":18.0, "interval":3.1, "damage":19.0, "trait":"clock", "visual":12},
	{"hp":235.0, "armor":9.0, "interval":2.9, "damage":18.0, "trait":"oracle", "visual":13},
	{"hp":280.0, "armor":20.0, "interval":4.1, "damage":22.0, "trait":"salt", "visual":14},
	{"hp":245.0, "armor":10.0, "interval":3.0, "damage":18.0, "trait":"serpent", "visual":15},
	{"hp":260.0, "armor":11.0, "interval":3.4, "damage":19.0, "trait":"star", "visual":16},
	{"hp":300.0, "armor":17.0, "interval":3.2, "damage":21.0, "trait":"widow", "visual":17}
]

var phase := "menu"
var hp := 100.0
var mana := 100.0
var max_hp := 100.0
var max_mana := 100.0
var class_id := 0
var player_level := 1
var enemy_attack_damage := 12.0
var enemy_interval := 4.5
var mana_regen := 0.0
var burn_bonus := 1.0
var slow_bonus := 1.0
var kills := 0
var run_goal := 10
var elapsed := 0.0
var lane := 0
var target_lane := 0
var locked := false
var attack_time := 4.5
var enemy_hp := 70.0
var enemy_max := 70.0
var enemy_type := 0
var encounter_order: Array = []
var location_order: Array = []
var location_index := 0
var intro_time := 0.0
var victory_time := 0.0
var round_clear_time := 0.0
var poison_time := 0.0
var enemy_poison := 0.0
var enemy_poison_time := 0.0
var shield := 0.0
var armor := 0.0
var burn := 0.0
var burn_time := 0.0
var slow_time := 0.0
var cooldown := 0.0
var dodge_cooldown := 0.0
var dodge_age := 9.0
var evasion_bonus := 0.0
var damage_bonus := 1.0
var mana_bonus := 0.0
var cost_bonus := 1.0
var discovered: Array = []

func start(profile_data: Dictionary = {}) -> void:
	var previous_order := encounter_order.duplicate()
	var rng := RandomNumberGenerator.new()
	if profile_data.has("seed"): rng.seed = int(profile_data.seed)
	else: rng.randomize()
	run_goal = mini(100, 10 * (maxi(0, int(profile_data.get("completed_runs", 0))) + 1))
	var ordinary := ORDINARY_TYPES.duplicate()
	var bosses := BOSS_TYPES.duplicate()
	var ordinary_index := ordinary.size()
	var boss_index := bosses.size()
	encounter_order.clear()
	for round_index in range(run_goal):
		var boss_round := is_boss_round(round_index)
		if boss_round:
			if boss_index >= bosses.size():
				_shuffle_with_rng(bosses, rng)
				if not encounter_order.is_empty() and bosses[0] == encounter_order.back(): bosses.reverse()
				boss_index = 0
			encounter_order.append(bosses[boss_index])
			boss_index += 1
		else:
			if ordinary_index >= ordinary.size():
				_shuffle_with_rng(ordinary, rng)
				if not encounter_order.is_empty() and ordinary[0] == encounter_order.back(): ordinary.reverse()
				ordinary_index = 0
			encounter_order.append(ordinary[ordinary_index])
			ordinary_index += 1
	if encounter_order == previous_order:
		var first = encounter_order[0]
		encounter_order[0] = encounter_order[1]
		encounter_order[1] = first
	location_order.clear()
	var places := range(13)
	var place_index := places.size()
	for i in range(ceili(run_goal / 2.0)):
		if place_index >= places.size():
			_shuffle_with_rng(places, rng)
			if not location_order.is_empty() and places[0] == location_order.back(): places.reverse()
			place_index = 0
		location_order.append(places[place_index])
		place_index += 1
	class_id = clampi(int(profile_data.get("class_id", 0)), 0, 4)
	var bonus: Dictionary = profile_data.get("bonuses", {})
	max_hp = 100.0 + (35.0 if class_id == 3 else 0.0) + float(bonus.get("hp", 0))
	max_mana = 100.0 + float(bonus.get("mana", 0))
	hp = max_hp
	mana = max_mana
	kills = 0
	elapsed = 0.0
	lane = 0
	damage_bonus = 1.0 + (0.10 if class_id == 0 else (0.15 if class_id == 4 else 0.0)) + float(bonus.get("damage", 0.0))
	mana_bonus = float(bonus.get("regen", 0.0))
	mana_regen = 3.0 if class_id == 2 else 0.0
	player_level = 1
	burn_bonus = (1.8 if class_id == 0 else 1.0) * (1.0 + float(bonus.get("burn", 0.0)))
	slow_bonus = (1.8 if class_id == 1 else 1.0) * (1.0 + float(bonus.get("slow", 0.0)))
	cost_bonus = 1.0
	poison_time = 0.0
	enemy_poison = 0.0
	enemy_poison_time = 0.0
	shield = 0.0
	evasion_bonus = 0.0
	apply_level(clampi(int(profile_data.get("level", 1)), 1, 50))
	_spawn()
	_show_location()

func apply_level(new_level: int) -> bool:
	new_level = clampi(new_level, 1, 50)
	if new_level <= player_level: return false
	var gained := new_level - player_level
	player_level = new_level
	max_hp += 1.5 * gained
	hp = minf(max_hp, hp + 4.0 * gained)
	max_mana += 0.35 * gained
	mana = minf(max_mana, mana + 2.0 * gained)
	damage_bonus += 0.008 * gained
	mana_regen += 0.025 * gained
	return true

func set_phase(value: String) -> void:
	phase = value
	phase_changed.emit()

func _spawn() -> void:
	enemy_type = int(encounter_order[kills])
	var enemy: Dictionary = ENEMIES[enemy_type]
	var boss := is_boss_type(enemy_type)
	var level_steps := float(player_level - 1)
	enemy_max = enemy.hp * (1.0 + level_steps * (0.018 if boss else 0.011)) * (1.0 + kills * 0.025)
	enemy_hp = enemy_max
	armor = enemy.armor + floorf(level_steps / (12.0 if boss else 20.0))
	enemy_attack_damage = enemy.damage * (1.0 + level_steps * (0.008 if boss else 0.005)) * (1.0 + kills * 0.012)
	enemy_interval = maxf(1.65, enemy.interval - level_steps * (0.008 if boss else 0.004))
	attack_time = enemy_interval
	locked = false
	burn = 0.0
	burn_time = 0.0
	enemy_poison_time = 0.0
	enemy_poison = 0.0
	slow_time = 0.0
	cooldown = 0.0
	dodge_cooldown = 0.0
	dodge_age = 9.0
	location_index = int(location_order[mini(kills / 2, location_order.size() - 1)])

func is_boss_type(index: int) -> bool:
	return index in BOSS_TYPES

func is_boss_round(round_index: int) -> bool:
	return round_index == run_goal - 1 or ((round_index + 1) % 3 == 0 and round_index != run_goal - 2)

func _show_location() -> void:
	intro_time = 2.2
	set_phase("intro")
	event.emit("location", location_index)

func _next_round() -> void:
	var old_location := location_index
	_spawn()
	if old_location != location_index:
		_show_location()
	else:
		set_phase("combat")

func advance(delta: float) -> void:
	if phase == "round_clear":
		round_clear_time -= delta
		if round_clear_time <= 0.0: _next_round()
		return
	if phase == "boss_victory":
		victory_time -= delta
		if victory_time <= 0.0: set_phase("reward")
		return
	if phase == "intro":
		intro_time -= delta
		if intro_time <= 0.0:
			set_phase("combat")
		return
	if phase != "combat":
		return
	elapsed += delta
	cooldown = maxf(0, cooldown - delta)
	dodge_cooldown = maxf(0, dodge_cooldown - delta)
	dodge_age += delta
	mana = minf(max_mana, mana + delta * (4.0 + mana_bonus + mana_regen))
	if class_id == 3: hp = minf(max_hp, hp + delta * 0.4)
	if poison_time > 0:
		var poison_tick := minf(delta, poison_time)
		poison_time -= poison_tick
		hp = maxf(0, hp - poison_tick * 2.5)
		if hp <= 0:
			set_phase("dead")
			return
	if burn_time > 0:
		var tick := minf(delta, burn_time)
		enemy_hp -= burn * tick
		burn_time -= tick
		if _check_kill():
			return
	if enemy_poison_time > 0:
		var poison_tick := minf(delta, enemy_poison_time)
		enemy_hp -= enemy_poison * poison_tick
		enemy_poison_time -= poison_tick
		if _check_kill(): return
	var speed := 0.48 if slow_time > 0 else 1.0
	slow_time = maxf(0, slow_time - delta)
	attack_time -= delta * speed
	if attack_time <= 1.1 and not locked:
		locked = true
		target_lane = lane
		event.emit("warning", 0)
	if attack_time <= 0:
		var next_interval := enemy_interval
		if lane == target_lane:
			var damage: float = maxf(0.0, enemy_attack_damage - shield)
			shield = maxf(0.0, shield - enemy_attack_damage)
			hp = maxf(0, hp - damage)
			event.emit("hurt", damage)
			match ENEMIES[enemy_type].trait:
				"heal": enemy_hp = minf(enemy_max, enemy_hp + 12)
				"poison": poison_time = 4.0
				"spores": poison_time = 5.5
				"drain": mana = maxf(0, mana - 14)
				"bell": mana = maxf(0, mana - 10)
				"clock": next_interval = maxf(1.4, enemy_interval * 0.75)
				"oracle": hp = maxf(0, hp - 3)
				"salt": shield = maxf(0.0, shield - 8.0)
				"serpent": poison_time = 6.0
				"star": mana = maxf(0.0, mana - 12.0)
				"widow": next_interval = maxf(1.4, enemy_interval * 0.8)
		else:
			var perfect := dodge_age <= 0.45
			var restored := (20.0 if perfect else 8.0) + (5.0 if class_id == 2 else 0.0)
			mana = minf(max_mana, mana + restored)
			if perfect:
				hp = minf(max_hp, hp + 4.0)
				evasion_bonus = minf(0.5, evasion_bonus + 0.25)
			event.emit("perfect_dodge" if perfect else "dodge", restored)
		attack_time = next_interval
		locked = false
		if hp <= 0:
			set_phase("dead")

func cast(a: int, b: int) -> bool:
	if phase != "combat" or cooldown > 0:
		return false
	var r := Catalog.recipe(a, b)
	var cost := ceilf(r.cost * cost_bonus)
	if mana < cost:
		event.emit("empty", 0)
		return false
	mana -= cost
	var damage: float = maxf(4, r.damage * damage_bonus * (1.0 + evasion_bonus) - (0.0 if r.pierce else armor))
	evasion_bonus = 0.0
	enemy_hp -= damage
	if ENEMIES[enemy_type].trait == "reflect":
		hp = maxf(0, hp - 4)
		event.emit("hurt", 4)
	burn = r.burn * damage_bonus * burn_bonus
	burn_time = r.duration
	enemy_poison = r.poison * (1.5 if class_id == 4 else 1.0)
	enemy_poison_time = r.duration if r.poison > 0 else 0.0
	shield = minf(45.0, shield + r.shield * (1.5 if class_id == 4 else 1.0))
	slow_time = maxf(slow_time, r.slow * slow_bonus)
	attack_time += r.stagger
	armor = maxf(0.0, armor - r.corrode)
	mana = minf(max_mana, mana + r.mana_return)
	hp = minf(max_hp, hp + r.heal * (1.5 if class_id == 3 else 1.0))
	cooldown = 0.8
	if not discovered.has(r.id):
		discovered.append(r.id)
		event.emit("discovery", 0)
	event.emit("cast", damage)
	_check_kill()
	if hp <= 0 and phase == "combat":
		set_phase("dead")
	return true

func _check_kill() -> bool:
	if enemy_hp > 0:
		return false
	kills += 1
	mana = minf(max_mana, mana + 14)
	event.emit("kill", 14)
	if kills >= run_goal:
		set_phase("won")
	elif is_boss_type(enemy_type):
		victory_time = 2.0
		set_phase("boss_victory")
	else:
		round_clear_time = 1.35
		set_phase("round_clear")
	return true

func dodge(direction: int) -> bool:
	if phase != "combat" or dodge_cooldown > 0.0: return false
	var next_lane := clampi(lane + direction, -1, 1)
	if next_lane == lane: return false
	lane = next_lane
	dodge_cooldown = 0.5
	dodge_age = 0.0
	event.emit("dodge_move", 0.0)
	return true

func upgrade(index: int) -> void:
	if phase != "reward":
		return
	match index:
		0: hp = minf(max_hp, hp + 35)
		1: damage_bonus += 0.2
		2:
			mana_bonus += 1.5
			mana = minf(max_mana, mana + 30)
	_next_round()

func snapshot() -> Dictionary:
	var data := {}
	for key in ["phase", "hp", "mana", "max_hp", "max_mana", "class_id", "player_level", "enemy_attack_damage", "enemy_interval", "mana_regen", "burn_bonus", "slow_bonus", "kills", "run_goal", "elapsed", "lane", "target_lane", "locked", "attack_time", "enemy_hp", "enemy_max", "enemy_type", "location_index", "location_order", "intro_time", "victory_time", "round_clear_time", "poison_time", "enemy_poison", "enemy_poison_time", "shield", "armor", "burn", "burn_time", "slow_time", "cooldown", "dodge_cooldown", "dodge_age", "evasion_bonus", "damage_bonus", "mana_bonus", "cost_bonus", "encounter_order"]:
		data[key] = get(key)
	return data

func restore(data: Dictionary) -> bool:
	var saved_goal := int(data.get("run_goal", 10))
	if saved_goal < 10 or saved_goal % 10 != 0 or saved_goal > 100: return false
	if int(data.get("kills", -1)) < 0 or int(data.get("kills", saved_goal)) >= saved_goal: return false
	if str(data.get("phase", "")) not in ["intro", "combat", "paused", "reward", "boss_victory", "round_clear"]: return false
	var saved_order: Array = data.get("encounter_order", [])
	if saved_order.is_empty(): saved_order = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
	if saved_order.size() != saved_goal: return false
	for i in range(saved_order.size()):
		var entry := int(saved_order[i])
		if entry < 0 or entry >= ENEMIES.size(): return false
		if is_boss_type(entry) != (i == saved_goal - 1 or ((i + 1) % 3 == 0 and i != saved_goal - 2)): return false
	var saved_locations: Array = data.get("location_order", [])
	if saved_locations.is_empty(): saved_locations = [0, 1, 2, 3, 4]
	if saved_locations.size() != ceili(saved_goal / 2.0): return false
	for entry in saved_locations:
		if int(entry) < 0 or int(entry) >= 13: return false
	for key in snapshot().keys():
		if data.has(key): set(key, data[key])
	encounter_order = saved_order.duplicate()
	location_order = saved_locations.duplicate()
	if phase == "paused": phase = "combat"
	phase_changed.emit()
	return true

func _shuffle_with_rng(values: Array, rng: RandomNumberGenerator) -> void:
	for i in range(values.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var temp = values[i]
		values[i] = values[j]
		values[j] = temp
