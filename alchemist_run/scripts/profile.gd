extends RefCounted

const CLASSES = ["ember", "frost", "storm", "vital", "shadow"]
const ITEMS = [
	{"id":"hood", "slot":"head", "price":80, "hp":12, "mana":0, "damage":0.0, "regen":0.0},
	{"id":"crown", "slot":"head", "price":280, "hp":0, "mana":18, "damage":0.0, "regen":0.0},
	{"id":"gloves", "slot":"hands", "price":120, "hp":0, "mana":0, "damage":0.08, "regen":0.0},
	{"id":"gauntlets", "slot":"hands", "price":360, "hp":0, "mana":0, "damage":0.16, "regen":0.0},
	{"id":"vial", "slot":"charm", "price":160, "hp":0, "mana":12, "damage":0.0, "regen":0.6},
	{"id":"heart", "slot":"charm", "price":430, "hp":25, "mana":0, "damage":0.0, "regen":0.3},
	{"id":"ash_boots", "slot":"feet", "price":100, "regen":0.4},
	{"id":"frost_boots", "slot":"feet", "price":250, "hp":8, "slow":0.10},
	{"id":"ember_ring", "slot":"ring", "price":140, "burn":0.12},
	{"id":"mercury_ring", "slot":"ring", "price":390, "mana":20, "regen":0.2},
	{"id":"plague_mask", "slot":"face", "price":180, "hp":16},
	{"id":"raven_mask", "slot":"face", "price":460, "damage":0.12},
	{"id":"copper_belt", "slot":"belt", "price":210, "hp":15, "mana":5},
	{"id":"storm_belt", "slot":"belt", "price":500, "regen":1.0},
	{"id":"glass_amulet", "slot":"charm", "price":560, "damage":0.13, "slow":0.10},
	{"id":"eclipse_amulet", "slot":"charm", "price":720, "damage":0.18, "burn":0.15},
	{"id":"ward_lantern", "slot":"charm", "price":600, "hp":18, "mana":10},
	{"id":"transfusion", "slot":"charm", "price":680, "hp":22, "regen":0.5},
	{"id":"dodge_boots", "slot":"feet", "price":620, "mana":15, "regen":0.8},
	{"id":"royal_crown", "slot":"head", "price":900, "hp":30, "damage":0.10}
]

const SLOTS = ["head", "hands", "charm", "feet", "ring", "face", "belt"]

var nickname := "Алхимик"
var avatar_index := 0
var class_id := 0
var xp := 0
var coins := 0
var completed_runs := 0
var golden_class_id := -1
var golden_avatar_index := -1
var claimed_milestones: Array = []
var reward_choices: Array = []
var reward_milestone := 0
var owned: Array = []
var item_levels := {}
var equipped := {"head":"", "hands":"", "charm":"", "feet":"", "ring":"", "face":"", "belt":""}

static func threshold(level: int) -> int:
	return int(ceil(300.0 * (pow(1.13, clampi(level, 1, 50) - 1) - 1.0)))

func level() -> int:
	return clampi(1 + int(floor(log(1.0 + float(xp) / 300.0) / log(1.13))), 1, 50)

func xp_progress() -> float:
	if level() >= 50: return 1.0
	var low := threshold(level())
	var high := threshold(level() + 1)
	return clampf(float(xp - low) / maxf(1.0, high - low), 0.0, 1.0)

func reward(enemy_index: int, run_tier: int = 0, played_class: int = -1) -> Dictionary:
	var old_level := level()
	var boss := enemy_index in [2, 5, 9, 10, 11, 12, 13, 14, 15, 16, 17]
	var gained_coins := (78 + enemy_index * 8) if boss else (13 + enemy_index * 3)
	var gained_xp := (115 + enemy_index * 20) if boss else (30 + enemy_index * 8)
	gained_coins = int(round(gained_coins * (1.0 + 0.35 * run_tier)))
	gained_xp = int(round(gained_xp * (1.0 + 0.25 * run_tier)))
	coins += gained_coins
	xp = mini(threshold(50), xp + gained_xp)
	if old_level < 50 and level() >= 50:
		golden_class_id = played_class if played_class >= 0 and played_class < CLASSES.size() else class_id
		golden_avatar_index = avatar_index
	return {"coins":gained_coins, "xp":gained_xp}

func next_milestone() -> int:
	for milestone in [10, 20, 30, 40, 50]:
		if level() >= milestone and not claimed_milestones.has(milestone): return milestone
	return 0

func possible_rewards() -> Array:
	var choices: Array = []
	for item in ITEMS:
		if not owned.has(item.id): choices.append({"id":item.id, "kind":"item"})
		elif item_level(item.id) < 5: choices.append({"id":item.id, "kind":"upgrade"})
	return choices

func has_milestone_reward() -> bool:
	return next_milestone() > 0 and not possible_rewards().is_empty()

func open_reward_offer() -> Array:
	if not has_milestone_reward(): return []
	var milestone := next_milestone()
	if reward_milestone == milestone and not reward_choices.is_empty(): return reward_choices
	var available := possible_rewards()
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	for i in range(available.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var temp = available[i]
		available[i] = available[j]
		available[j] = temp
	reward_choices = available.slice(0, mini(3, available.size()))
	reward_milestone = milestone
	return reward_choices

func claim_reward_choice(index: int) -> bool:
	if reward_milestone != next_milestone() or index < 0 or index >= reward_choices.size(): return false
	var choice: Dictionary = reward_choices[index]
	var id := str(choice.get("id", ""))
	if choice.get("kind", "") == "item" and not owned.has(id):
		owned.append(id)
		item_levels[id] = 1
		equip(id)
	elif choice.get("kind", "") == "upgrade" and owned.has(id) and item_level(id) < 5:
		item_levels[id] = item_level(id) + 1
	else: return false
	claimed_milestones.append(reward_milestone)
	reward_choices.clear()
	reward_milestone = 0
	return true

func buy(id: String) -> bool:
	for item in ITEMS:
		if item.id == id:
			if owned.has(id) or coins < item.price: return false
			coins -= item.price
			owned.append(id)
			item_levels[id] = 1
			equip(id)
			return true
	return false

func equip(id: String) -> bool:
	if not owned.has(id): return false
	for item in ITEMS:
		if item.id == id:
			equipped[item.slot] = id
			return true
	return false

func item_level(id: String) -> int:
	return clampi(int(item_levels.get(id, 1 if owned.has(id) else 0)), 0, 5)

func upgrade_cost(id: String) -> int:
	var current := item_level(id)
	if current < 1 or current >= 5: return 0
	for item in ITEMS:
		if item.id == id: return int(ceil(item.price * (0.45 + 0.2 * current) * current))
	return 0

func upgrade_item(id: String) -> bool:
	var cost := upgrade_cost(id)
	if cost <= 0 or coins < cost: return false
	coins -= cost
	item_levels[id] = item_level(id) + 1
	return true

func bonuses() -> Dictionary:
	var result := {"hp":0.0, "mana":0.0, "damage":0.0, "regen":0.0, "burn":0.0, "slow":0.0}
	for item in ITEMS:
		if equipped.get(item.slot, "") == item.id:
			var multiplier := 1.0 + 0.25 * (item_level(item.id) - 1)
			for key in result: result[key] += float(item.get(key, 0.0)) * multiplier
	return result

func reset() -> void:
	nickname = "Алхимик"
	avatar_index = 0
	class_id = 0
	xp = 0
	coins = 0
	completed_runs = 0
	golden_class_id = -1
	golden_avatar_index = -1
	claimed_milestones.clear()
	reward_choices.clear()
	reward_milestone = 0
	owned.clear()
	item_levels.clear()
	equipped = {"head":"", "hands":"", "charm":"", "feet":"", "ring":"", "face":"", "belt":""}

func to_dict() -> Dictionary:
	return {"nickname":nickname, "avatar_index":avatar_index, "class_id":class_id, "xp":xp, "coins":coins, "completed_runs":completed_runs, "golden_class_id":golden_class_id, "golden_avatar_index":golden_avatar_index, "claimed_milestones":claimed_milestones.duplicate(), "reward_choices":reward_choices.duplicate(true), "reward_milestone":reward_milestone, "owned":owned.duplicate(), "item_levels":item_levels.duplicate(), "equipped":equipped.duplicate()}

func from_dict(data: Dictionary) -> void:
	nickname = str(data.get("nickname", "Алхимик")).substr(0, 20)
	avatar_index = clampi(int(data.get("avatar_index", 0)), 0, 9)
	class_id = clampi(int(data.get("class_id", 0)), 0, 4)
	xp = clampi(int(data.get("xp", 0)), 0, threshold(50))
	coins = maxi(0, int(data.get("coins", 0)))
	completed_runs = maxi(0, int(data.get("completed_runs", 0)))
	golden_class_id = clampi(int(data.get("golden_class_id", -1)), -1, 4)
	golden_avatar_index = clampi(int(data.get("golden_avatar_index", -1)), -1, 9)
	claimed_milestones.clear()
	for milestone in [10, 20, 30, 40, 50]:
		if data.get("claimed_milestones", []).has(milestone): claimed_milestones.append(milestone)
	reward_milestone = int(data.get("reward_milestone", 0))
	reward_choices = data.get("reward_choices", []).duplicate(true)
	if reward_milestone != next_milestone(): reward_choices.clear(); reward_milestone = 0
	if level() >= 50 and golden_class_id < 0:
		golden_class_id = class_id
		golden_avatar_index = avatar_index
	owned.clear()
	var saved_owned: Array = data.get("owned", [])
	for item in ITEMS:
		if saved_owned.has(item.id): owned.append(item.id)
	item_levels.clear()
	var saved_levels: Dictionary = data.get("item_levels", {})
	for id in owned: item_levels[id] = clampi(int(saved_levels.get(id, 1)), 1, 5)
	var saved: Dictionary = data.get("equipped", {})
	equipped = {}
	for slot in SLOTS:
		var id := str(saved.get(slot, ""))
		equipped[slot] = id if owned.has(id) else ""
