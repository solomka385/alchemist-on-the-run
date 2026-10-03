extends SceneTree

const Catalog = preload("res://scripts/catalog.gd")
const RunModel = preload("res://scripts/run_model.gd")
const Locale = preload("res://scripts/locale.gd")
const Profile = preload("res://scripts/profile.gd")
var failures := 0
var checks := 0

func _initialize() -> void:
	_check(Catalog.RECIPES.size() == 36, "all 36 pairs")
	for i in range(12):
		for j in range(12):
			_check(Catalog.recipe(i, j).id == Catalog.recipe(j, i).id, "commutative recipe %d %d" % [i, j])
	_check(Catalog.CLASS_LOADOUTS.size() == 5 and Catalog.CLASS_LOADOUTS.all(func(loadout): return loadout.size() == 4), "five four-ingredient classes")
	_check(Catalog.recipe(8, 8).poison > 0 and Catalog.recipe(9, 9).shield > 0 and Catalog.recipe(10, 10).stagger > 0 and Catalog.recipe(11, 11).heal > 0, "new ingredients have distinct effects")
	_check(Locale.get_text("ru", "moss") != "moss", "Russian text")
	_check(Locale.get_text("en", "moss") != "moss", "English text")
	_check(Locale.LANGUAGES.size() == 15, "15 languages available")
	for entry in Locale.LANGUAGES:
		_check(Locale.get_text(entry.code, "title") != "" and Locale.get_text(entry.code, "profile") != "", "language UI %s" % entry.code)
		_check(Locale.get_text(entry.code, "item_hood") != "" and Locale.get_text(entry.code, "item_hood_desc") != "", "language shop %s" % entry.code)
		_check(Locale.get_text(entry.code, "class_ember") != "" and Locale.get_text(entry.code, "slot_head") != "", "language profile %s" % entry.code)
		_check(Locale.get_text(entry.code, "level_up") != "" and Locale.get_text(entry.code, "level_effect") != "", "language level %s" % entry.code)
		_check(Locale.get_text(entry.code, "enemy_down") != "" and Locale.get_text(entry.code, "shop_hint") != "", "language expansion UI %s" % entry.code)
		_check(Locale.get_text(entry.code, "class_shadow") != "" and Locale.get_text(entry.code, "item_royal_crown") != "" and Locale.get_text(entry.code, "tutorial_step_3") != "", "language new class item tutorial %s" % entry.code)
	for location in range(13):
		_check(FileAccess.file_exists("res://assets/audio/location_%d.wav" % location), "location music %d" % location)
	for boss_id in RunModel.BOSS_TYPES:
		for cue in ["intro", "attack", "death"]:
			_check(FileAccess.file_exists("res://assets/audio/boss_%d_%s.wav" % [boss_id, cue]), "boss audio %d %s" % [boss_id, cue])
	for asset_name in ["bell_king", "fungal_queen", "clock_knight", "ash_oracle", "aqueduct", "observatory", "salt_cathedral", "clock_tower"]:
		_check(FileAccess.file_exists("res://assets/%s_game.png" % asset_name), "expansion art %s" % asset_name)
	var profile = Profile.new()
	_check(Profile.threshold(2) < Profile.threshold(3) and Profile.threshold(49) < Profile.threshold(50), "increasing XP thresholds")
	profile.xp = Profile.threshold(10)
	_check(profile.level() == 10, "logarithmic level 10")
	profile.xp = Profile.threshold(50)
	_check(profile.level() == 50, "level cap")
	var reward_profile = Profile.new()
	reward_profile.xp = Profile.threshold(50)
	_check(reward_profile.has_milestone_reward() and reward_profile.next_milestone() == 10, "first unclaimed milestone available")
	var offer: Array = reward_profile.open_reward_offer()
	_check(offer.size() == 3 and offer == reward_profile.open_reward_offer(), "three stable random reward choices")
	_check(reward_profile.claim_reward_choice(0) and reward_profile.claimed_milestones.has(10), "milestone reward claimed once")
	_check(not reward_profile.claim_reward_choice(0), "milestone cannot duplicate")
	_check(reward_profile.next_milestone() == 20, "next milestone unlocks in sequence")
	for item in Profile.ITEMS:
		if not reward_profile.owned.has(item.id): reward_profile.owned.append(item.id)
		reward_profile.item_levels[item.id] = 1
	var upgrade_offer: Array = reward_profile.open_reward_offer()
	_check(upgrade_offer.size() == 3 and upgrade_offer.all(func(choice): return choice.kind == "upgrade"), "full collection offers upgrades without duplicate items")
	for item in Profile.ITEMS:
		reward_profile.item_levels[item.id] = 5
	_check(not reward_profile.has_milestone_reward() and reward_profile.open_reward_offer().is_empty(), "fully upgraded collection hides milestone rewards")
	var crown_profile = Profile.new()
	crown_profile.class_id = 1
	crown_profile.avatar_index = 9
	crown_profile.xp = Profile.threshold(50) - 1
	crown_profile.reward(2, 0, 4)
	_check(crown_profile.level() == 50 and crown_profile.golden_class_id == 4 and crown_profile.golden_avatar_index == 9, "level fifty remembers crowned class and avatar")
	profile.coins = 120
	_check(profile.buy("gloves") and profile.coins == 0 and profile.equipped.hands == "gloves", "shop purchase and equip")
	_check(not profile.buy("gloves"), "cannot buy twice")
	profile.coins = 150
	_check(profile.buy("ember_ring") and profile.bonuses().burn > 0.0, "new item burn bonus")
	profile.coins = 500
	_check(profile.buy("storm_belt") and profile.bonuses().regen >= 1.0, "new item regen bonus")
	profile.coins = 5000
	var base_glove_damage: float = profile.bonuses().damage
	_check(profile.item_level("gloves") == 1 and profile.upgrade_item("gloves") and profile.item_level("gloves") == 2 and profile.bonuses().damage > base_glove_damage, "item upgrade raises equipped bonus")
	for extra_level in range(3): profile.upgrade_item("gloves")
	_check(profile.item_level("gloves") == 5 and profile.upgrade_cost("gloves") == 0 and not profile.upgrade_item("gloves"), "item upgrade stops at level five")
	profile.completed_runs = 2
	var saved_profile: Dictionary = profile.to_dict()
	var restored_profile = Profile.new()
	restored_profile.from_dict(saved_profile)
	_check(restored_profile.level() == 50 and restored_profile.equipped.hands == "gloves" and restored_profile.item_level("gloves") == 5 and restored_profile.completed_runs == 2, "profile roundtrip")
	restored_profile.reset()
	_check(restored_profile.level() == 1 and restored_profile.owned.is_empty() and restored_profile.completed_runs == 0, "profile reset")
	var game = RunModel.new()
	game.start()
	_check(game.phase == "intro" and game.hp == 100 and game.run_goal == 10 and game.location_index == game.location_order[0], "new run intro")
	var all_types: Array = game.encounter_order.duplicate()
	_check(all_types.size() == 10 and all_types.duplicate().filter(func(x): return all_types.count(x) != 1).is_empty(), "first run encounters unique")
	_check(game.is_boss_type(game.encounter_order[2]) and game.is_boss_type(game.encounter_order[5]) and game.is_boss_type(game.encounter_order[9]), "boss slots unique")
	var seeded_a = RunModel.new()
	seeded_a.start({"seed":42})
	var seeded_b = RunModel.new()
	seeded_b.start({"seed":43})
	_check(seeded_a.encounter_order != seeded_b.encounter_order, "runs vary with random seed")
	var previous_seeded_order: Array = seeded_a.encounter_order.duplicate()
	seeded_a.start({"seed":42})
	_check(seeded_a.encounter_order != previous_seeded_order, "consecutive runs cannot repeat same order")
	for seed_value in range(50):
		var sampled = RunModel.new()
		sampled.start({"seed":seed_value})
		var order: Array = sampled.encounter_order.duplicate()
		var boss_types := [order[2], order[5], order[9]]
		_check(order.size() == 10 and order.duplicate().filter(func(x): return order.count(x) != 1).is_empty() and boss_types.all(func(x): return sampled.is_boss_type(x)), "random encounter seed %d" % seed_value)
		_check(sampled.location_order.size() == 5 and sampled.location_order.duplicate().filter(func(x): return sampled.location_order.count(x) != 1).is_empty(), "random location seed %d" % seed_value)
	var class_game = RunModel.new()
	class_game.start({"class_id":3, "bonuses":{"hp":12, "mana":18, "damage":0.08, "regen":0.6}})
	_check(class_game.max_hp == 147 and class_game.max_mana == 118 and class_game.damage_bonus > 1.0, "vitalist equipment bonuses")
	class_game.start({"class_id":0})
	_check(class_game.burn_bonus > 1.0, "ember school bonus")
	class_game.start({"class_id":1})
	_check(class_game.slow_bonus > 1.0, "frost school bonus")
	class_game.start({"class_id":2})
	_check(class_game.mana_regen > 0.0, "storm school bonus")
	class_game.start({"class_id":4})
	_check(class_game.damage_bonus >= 1.15, "shadow school damage bonus")
	var novice = RunModel.new()
	novice.start({"seed":11, "level":1})
	var veteran = RunModel.new()
	veteran.start({"seed":11, "level":50})
	_check(veteran.player_level == 50 and veteran.max_hp > novice.max_hp and veteran.max_mana > novice.max_mana and veteran.damage_bonus > novice.damage_bonus and veteran.mana_regen > novice.mana_regen, "level raises combat stats")
	_check(veteran.enemy_max > novice.enemy_max and veteran.enemy_attack_damage > novice.enemy_attack_damage and veteran.enemy_interval < novice.enemy_interval, "regular enemy scales with player")
	var hp_at_level: float = novice.max_hp
	_check(novice.apply_level(2) and novice.max_hp > hp_at_level and novice.hp > hp_at_level, "mid-run level applies immediately")
	_check(not novice.apply_level(2), "level benefit cannot apply twice")
	veteran.kills = 2
	novice.kills = 2
	veteran._spawn()
	novice._spawn()
	_check(veteran.is_boss_type(veteran.enemy_type) and veteran.enemy_max > novice.enemy_max and veteran.enemy_attack_damage > novice.enemy_attack_damage, "boss scales with player")
	var veteran_save: Dictionary = veteran.snapshot()
	var veteran_restore = RunModel.new()
	_check(veteran_restore.restore(veteran_save) and veteran_restore.player_level == 50 and is_equal_approx(veteran_restore.enemy_max, veteran.enemy_max), "level and boss scaling survive save")
	game.advance(2.3)
	_check(game.phase == "combat", "intro completes")
	var cast_success: bool = game.cast(0, 1)
	_check(cast_success and game.mana < 100 and game.enemy_hp < game.enemy_max, "potion cast")
	game.cooldown = 0
	game.mana = 0
	_check(not game.cast(0, 1), "empty mana")
	_check(not game.cast(0, 1), "no free shard")
	game.attack_time = 0.5
	game.slow_time = 0.0
	game.advance(0.1)
	game.dodge(1)
	var hp_before: float = game.hp
	var mana_before: float = game.mana
	game.advance(0.41)
	_check(game.hp >= hp_before and game.mana > mana_before and game.evasion_bonus > 0.0, "perfect dodge heals, restores mana, and boosts next throw")
	_check(not game.dodge(1), "dodge has a short cooldown")
	game.enemy_hp = 1
	game.cooldown = 0
	game.mana = 100
	game.cast(0, 1)
	_check(game.kills == 1 and game.phase == "round_clear", "enemy defeated with breathing room")
	game.advance(0.6)
	_check(game.phase == "round_clear", "next enemy does not appear immediately")
	game.advance(0.8)
	_check(game.phase == "combat", "same location transition completes")
	game.enemy_hp = 1
	game.cooldown = 0
	game.mana = 100
	game.cast(0, 1)
	_check(game.kills == 2 and game.phase == "round_clear", "second enemy transition")
	game.advance(1.4)
	_check(game.phase == "intro" and game.location_index == game.location_order[1] and game.location_index != game.location_order[0], "new location after two rounds")
	game.advance(2.3)
	_check(game.is_boss_type(game.enemy_type) and game.phase == "combat", "first boss in round three")
	var snapshot: Dictionary = game.snapshot()
	var resumed = RunModel.new()
	_check(resumed.restore(snapshot) and resumed.kills == 2 and resumed.enemy_type == game.enemy_type and resumed.encounter_order == game.encounter_order, "run snapshot roundtrip")
	for round_index in range(2, game.run_goal):
		game.enemy_hp = 1
		game.cooldown = 0
		game.mana = game.max_mana
		game.cast(0, 1)
		_check(game.kills == round_index + 1, "round %d ends" % (round_index + 1))
		if game.phase == "boss_victory":
			_check(game.victory_time > 0, "boss victory pause")
			game.advance(2.1)
		if game.phase == "reward": game.upgrade(0)
		if game.phase == "round_clear": game.advance(1.4)
		if game.phase == "intro": game.advance(2.3)
		if game.kills < game.run_goal:
			_check(game.enemy_type == game.encounter_order[game.kills], "new enemy for round %d" % (game.kills + 1))
			_check(game.location_index == game.location_order[game.kills / 2], "location for round %d" % (game.kills + 1))
	_check(game.phase == "won", "final victory")
	var second_run = RunModel.new()
	second_run.start({"seed":1337, "completed_runs":1})
	_check(second_run.run_goal == 20 and second_run.encounter_order.size() == 20 and second_run.location_order.size() == 10, "second run has twenty rounds")
	for index in range(second_run.run_goal):
		_check(second_run.is_boss_type(second_run.encounter_order[index]) == second_run.is_boss_round(index), "second run boss slot %d" % index)
	second_run.advance(2.3)
	for round_index in range(second_run.run_goal):
		second_run.enemy_hp = 1
		second_run.cooldown = 0
		second_run.mana = second_run.max_mana
		second_run.cast(0, 1)
		_check(second_run.kills == round_index + 1, "second run round %d" % round_index)
		if second_run.phase == "boss_victory": second_run.advance(2.1)
		if second_run.phase == "reward": second_run.upgrade(0)
		if second_run.phase == "round_clear": second_run.advance(1.4)
		if second_run.phase == "intro": second_run.advance(2.3)
	_check(second_run.phase == "won", "twenty round victory")
	var third_run = RunModel.new()
	third_run.start({"seed":1338, "completed_runs":2})
	_check(third_run.run_goal == 30 and third_run.encounter_order.size() == 30 and third_run.location_order.size() == 15, "third run adds ten more rounds")
	var capped_run = RunModel.new()
	capped_run.start({"seed":57, "completed_runs":99})
	_check(capped_run.run_goal == 100 and capped_run.encounter_order.size() == 100 and capped_run.location_order.size() == 50, "run length caps at 100")
	_check(RunModel.new().restore(capped_run.snapshot()), "100-round run restores")
	for location_step in range(1, third_run.location_order.size()):
		_check(third_run.location_order[location_step] != third_run.location_order[location_step - 1], "location cycle avoids adjacent repeat %d" % location_step)
	for round_index in range(1, third_run.encounter_order.size()):
		_check(third_run.encounter_order[round_index] != third_run.encounter_order[round_index - 1], "enemy cycle avoids adjacent repeat %d" % round_index)
	for boss_id in [10, 11, 12, 13]:
		var new_boss = RunModel.new()
		new_boss.start({"seed":23})
		new_boss.encounter_order[2] = boss_id
		new_boss.kills = 2
		new_boss._spawn()
		new_boss.set_phase("combat")
		new_boss.attack_time = 0.05
		new_boss.locked = true
		new_boss.target_lane = new_boss.lane
		new_boss.advance(0.1)
		match boss_id:
			10: _check(new_boss.mana < new_boss.max_mana - 8, "bell boss drains mana")
			11: _check(new_boss.poison_time > 5.0, "fungal boss poisons")
			12: _check(new_boss.attack_time < new_boss.enemy_interval, "clock boss accelerates")
			13: _check(new_boss.hp < new_boss.max_hp - new_boss.enemy_attack_damage, "oracle boss curses")
	print("GAME TESTS %d checks, %d failures" % [checks, failures])
	quit(0 if failures == 0 else 1)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error("FAIL: " + label)
