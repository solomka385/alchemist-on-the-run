extends SceneTree

func _initialize() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var game = load("res://main.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	game.language = "ru"
	game.last_menu_location = 2
	await process_frame
	await process_frame
	await process_frame
	root.get_texture().get_image().save_png("res://tests/menu_capture.png")
	game.profile.coins = 5000
	game.profile.buy("hood")
	for i in range(4): game.profile.upgrade_item("hood")
	game.overlay = "profile"
	await process_frame
	root.get_texture().get_image().save_png("res://tests/profile_capture.png")
	game.profile.xp = 350000
	game.profile.claimed_milestones.clear()
	game.profile.open_reward_offer()
	game.overlay = "milestone"
	await process_frame
	root.get_texture().get_image().save_png("res://tests/milestone_capture.png")
	game.toast_time = 0.0
	game.overlay = "shop"
	await process_frame
	root.get_texture().get_image().save_png("res://tests/shop_capture.png")
	game.shop_page = 1
	await process_frame
	root.get_texture().get_image().save_png("res://tests/shop_page2_capture.png")
	game.shop_page = 0
	game.overlay = "class"
	await process_frame
	root.get_texture().get_image().save_png("res://tests/class_capture.png")
	game.overlay = "tutorial"
	await process_frame
	root.get_texture().get_image().save_png("res://tests/tutorial_capture.png")
	game.overlay = ""
	game.model.start()
	await process_frame
	await process_frame
	root.get_texture().get_image().save_png("res://tests/intro_capture.png")
	game.model.advance(2.3)
	await process_frame
	await process_frame
	root.get_texture().get_image().save_png("res://tests/combat_capture.png")
	game.model.enemy_hp = 1
	game.model.cast(0, 1)
	await process_frame
	root.get_texture().get_image().save_png("res://tests/round_clear_capture.png")
	game.model.advance(1.4)
	game.overlay = "settings"
	await process_frame
	await process_frame
	root.get_texture().get_image().save_png("res://tests/settings_capture.png")
	game.overlay = "language_list"
	await process_frame
	root.get_texture().get_image().save_png("res://tests/language_capture.png")
	game.overlay = ""
	game.model.set_phase("reward")
	await process_frame
	root.get_texture().get_image().save_png("res://tests/reward_capture.png")
	game.model.set_phase("combat")
	game.overlay = ""
	game.model.kills = 2
	game.model._spawn()
	game.model._show_location()
	game.model.advance(2.3)
	await process_frame
	await process_frame
	root.get_texture().get_image().save_png("res://tests/boss_capture.png")
	game.model.encounter_order[2] = 14
	game.model._spawn()
	await process_frame
	root.get_texture().get_image().save_png("res://tests/salt_giant_capture.png")
	game.model.encounter_order[2] = 2
	game.model._spawn()
	game.model.enemy_hp = 1
	game.model.cast(0, 1)
	await process_frame
	root.get_texture().get_image().save_png("res://tests/boss_victory_capture.png")
	game.model.kills = 5
	game.model._spawn()
	game.model._show_location()
	game.model.advance(2.3)
	await process_frame
	await process_frame
	root.get_texture().get_image().save_png("res://tests/glass_capture.png")
	game.model.kills = 9
	game.model._spawn()
	game.model._show_location()
	game.model.advance(2.3)
	await process_frame
	await process_frame
	root.get_texture().get_image().save_png("res://tests/final_capture.png")
	game.language = "en"
	await process_frame
	await process_frame
	root.get_texture().get_image().save_png("res://tests/english_capture.png")
	game.overlay = "settings"
	await process_frame
	await process_frame
	root.get_texture().get_image().save_png("res://tests/english_settings_capture.png")
	game.model.set_phase("menu")
	game.overlay = ""
	game.language = "zh"
	await process_frame
	root.get_texture().get_image().save_png("res://tests/chinese_capture.png")
	game.overlay = "shop"
	await process_frame
	root.get_texture().get_image().save_png("res://tests/chinese_shop_capture.png")
	game.overlay = "class"
	await process_frame
	root.get_texture().get_image().save_png("res://tests/chinese_class_capture.png")
	game.overlay = ""
	game.language = "ar"
	await process_frame
	root.get_texture().get_image().save_png("res://tests/arabic_capture.png")
	game.overlay = "shop"
	await process_frame
	root.get_texture().get_image().save_png("res://tests/arabic_shop_capture.png")
	game.overlay = ""
	game.language = "ru"
	game.profile.class_id = 4
	game.model.start({"class_id":4})
	game.left_ingredient = 8
	game.right_ingredient = 9
	game.model.advance(2.3)
	await process_frame
	root.get_texture().get_image().save_png("res://tests/shadow_combat_capture.png")
	game.model.set_phase("menu")
	game.profile.xp = 350000
	game.profile.golden_class_id = 4
	game.profile.golden_avatar_index = 9
	game.profile.avatar_index = 9
	game.overlay = "profile"
	await process_frame
	root.get_texture().get_image().save_png("res://tests/crown_profile_capture.png")
	quit()
