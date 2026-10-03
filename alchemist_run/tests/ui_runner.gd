extends SceneTree

var failed := 0
var checks := 0

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var game = load("res://main.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	game.profile.reset()
	game._save_profile()
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://run.cfg"))
	_check(game.model.phase == "menu", "menu opens")
	game._handle_tap(Vector2(320, 669))
	_check(game.overlay == "settings", "settings open")
	var old_language: String = game.language
	game._handle_tap(Vector2(210, 280))
	_check(game.overlay == "language_list", "language dropdown opens")
	var language_index := 1 if old_language != "en" else 0
	game._handle_tap(Vector2(130 + (language_index % 2) * 202, 182 + (language_index / 2) * 58))
	_check(game.language != old_language and game.overlay == "settings", "language dropdown selects")
	var old_music: bool = game.music_on
	game._handle_tap(Vector2(210, 350))
	_check(game.music_on != old_music, "music toggle")
	var old_sound: bool = game.sound_on
	game._handle_tap(Vector2(210, 420))
	_check(game.sound_on != old_sound, "effects toggle")
	var old_vibration: bool = game.vibration_on
	game._handle_tap(Vector2(210, 490))
	_check(game.vibration_on != old_vibration, "vibration toggle")
	_check(FileAccess.file_exists("user://alchemist.cfg"), "settings persisted")
	game._handle_tap(Vector2(210, 605))
	game._handle_tap(Vector2(150, 531))
	_check(game.overlay == "profile", "profile open")
	game._handle_tap(Vector2(237, 431))
	_check(game.profile.avatar_index == 2, "avatar selection")
	game._handle_tap(Vector2(200, 320))
	_check(game.nickname_input.visible, "nickname editor open")
	game.nickname_input.text = "Тестовый алхимик"
	game._handle_tap(Vector2(290, 708))
	_check(not game.nickname_input.visible and game.profile.nickname == "Тестовый алхимик", "nickname editor closes on back")
	var profile_config := ConfigFile.new()
	profile_config.load("user://profile.cfg")
	_check(profile_config.get_value("profile", "data", {}).get("nickname", "") == "Тестовый алхимик", "nickname saved")
	game._handle_tap(Vector2(330, 531))
	_check(game.overlay == "shop", "shop open")
	game.profile.coins = 5000
	game.profile.owned.erase("hood")
	game.profile.item_levels.erase("hood")
	game.profile.equipped.head = ""
	game._handle_tap(Vector2(100, 165))
	_check(game.profile.item_level("hood") == 1, "shop buys level one item")
	for i in range(4): game._handle_tap(Vector2(360, 177))
	_check(game.profile.item_level("hood") == 5, "shop upgrades to level five")
	game._handle_tap(Vector2(381, 705))
	_check(game.shop_page == 1, "shop second page")
	game._handle_tap(Vector2(381, 705))
	game._handle_tap(Vector2(381, 705))
	_check(game.shop_page == 3, "shop fourth page")
	game._handle_tap(Vector2(84, 705))
	_check(game.shop_page == 2, "shop previous page")
	game._handle_tap(Vector2(220, 710))
	game.profile.completed_runs = 1
	game._handle_tap(Vector2(210, 460))
	_check(game.overlay == "class", "class select")
	game._handle_tap(Vector2(200, 353))
	_check(game.profile.class_id == 2, "class selection")
	game._handle_tap(Vector2(210, 681))
	_check(game.model.phase == "intro" and game.model.run_goal == 20, "next run has twenty rounds")
	_check(FileAccess.file_exists("user://run.cfg"), "run persisted")
	game.model.advance(2.3)
	_check(game.model.phase == "combat", "combat begins")
	game._handle_tap(Vector2(390, 735))
	_check(game.left_ingredient == 7 and game.active_hand == 1, "left flask selection")
	game._handle_tap(Vector2(180, 735))
	_check(game.right_ingredient == 3 and game.active_hand == 0, "right flask selection")
	var mana_before_cast: float = game.model.mana
	game._handle_tap(Vector2(300, 810))
	_check(game.model.mana < mana_before_cast and game.model.enemy_hp < game.model.enemy_max, "mix and throw")
	game._handle_tap(Vector2(425, 50))
	_check(game.overlay == "pause" and game.model.phase == "paused", "pause")
	game._handle_tap(Vector2(220, 388))
	_check(game.overlay == "" and game.model.phase == "combat", "resume")
	game.model.enemy_hp = 1
	game.model.cooldown = 0
	game.model.mana = game.model.max_mana
	game._cast()
	_check(game.model.phase == "round_clear", "non-boss victory pauses before next foe")
	var saved_kills: int = game.model.kills
	var saved_mana: float = game.model.mana
	game._save_run()
	_stop_audio(game)
	game.queue_free()
	await process_frame
	var game2 = load("res://main.tscn").instantiate()
	root.add_child(game2)
	current_scene = game2
	game2._continue_run()
	_check(game2.model.phase == "round_clear" and game2.model.kills == saved_kills and is_equal_approx(game2.model.mana, saved_mana), "continue restores transition")
	game2.model.advance(1.4)
	_check(game2.model.phase == "combat", "restored transition completes")
	var completed_before: int = game2.profile.completed_runs
	game2.model.set_phase("won")
	_check(game2.profile.completed_runs == completed_before + 1 and not FileAccess.file_exists("user://run.cfg"), "victory unlocks longer run and removes save")
	game2._start_run()
	_check(game2.model.run_goal == 10 * (completed_before + 2), "next run grows by ten")
	var active_enemy: int = game2.model.enemy_type
	game2._save_run()
	game2.model.set_phase("menu")
	game2._handle_tap(Vector2(200, 390))
	_check(game2.model.enemy_type == active_enemy and game2.model.phase == "intro", "continue button resumes active saved run from menu")
	game2.model.set_phase("dead")
	_check(not FileAccess.file_exists("user://run.cfg"), "finished run removed")
	game2.model.set_phase("menu")
	game2.profile.xp = game2.profile.threshold(10)
	game2.profile.claimed_milestones.clear()
	game2._handle_tap(Vector2(145, 530))
	_check(game2.overlay == "profile" and game2.profile.has_milestone_reward(), "profile shows milestone reward")
	game2._handle_tap(Vector2(200, 670))
	_check(game2.overlay == "milestone" and game2.profile.reward_choices.size() == 3, "milestone presents three choices")
	var reward_id: String = game2.profile.reward_choices[0].id
	var before_level: int = game2.profile.item_level(reward_id)
	game2._handle_tap(Vector2(210, 344))
	_check(game2.overlay == "profile" and game2.profile.item_level(reward_id) == before_level + 1, "claimed reward grants item or upgrade")
	game2._handle_tap(Vector2(320, 727))
	game2._start_run()
	game2._save_run()
	game2.model.set_phase("menu")
	game2._handle_tap(Vector2(145, 670))
	_check(game2.overlay == "tutorial", "tutorial opens from main menu")
	game2._handle_tap(Vector2(210, 512))
	game2.model.advance(2.3)
	_check(game2.tutorial_stage == 0 and game2.model.is_boss_type(game2.model.enemy_type), "guided boss lesson starts")
	game2._choose(2)
	_check(game2.tutorial_stage == 0, "tutorial restricts wrong ingredient")
	game2._choose(0)
	game2._choose(1)
	_check(game2.tutorial_stage == 2 and game2.left_ingredient == 0 and game2.right_ingredient == 2, "tutorial guides both hands")
	game2._cast()
	_check(game2.tutorial_stage == 3 and game2.model.enemy_hp < game2.model.enemy_max, "tutorial guides first throw")
	game2.model.advance(1.2)
	game2.model.dodge(1)
	_check(game2.tutorial_stage == 4, "tutorial guides dodge after attack marker")
	game2.model.enemy_hp = 1
	game2.model.cooldown = 0
	game2.model.mana = game2.model.max_mana
	game2._cast()
	await process_frame
	_check(game2.tutorial_stage == -1 and game2.model.phase == "menu", "boss defeat finishes tutorial")
	_check(FileAccess.file_exists("user://run.cfg"), "tutorial preserves active run")
	game2._handle_tap(Vector2(200, 389))
	_check(game2.model.phase == "intro" and game2.tutorial_stage == -1, "continue after tutorial resumes original run")
	print("UI TESTS %d checks, %d failures" % [checks, failed])
	current_scene = null
	_stop_audio(game2)
	game2.queue_free()
	await process_frame
	game = null
	game2 = null
	quit(0 if failed == 0 else 1)

func _stop_audio(game) -> void:
	game.music_player.stop()
	game.music_next_player.stop()
	for player in game.effect_players: player.stop()

func _check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		failed += 1
		push_error("FAIL: " + label)
