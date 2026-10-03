extends Control

const Catalog = preload("res://scripts/catalog.gd")
const Locale = preload("res://scripts/locale.gd")
const RunModel = preload("res://scripts/run_model.gd")
const Profile = preload("res://scripts/profile.gd")
const CORRIDOR = preload("res://assets/corridor_game.png")
const GREENHOUSE = preload("res://assets/greenhouse_game.png")
const GLASSWORKS = preload("res://assets/glassworks_game.png")
const ARCHIVES = preload("res://assets/archives_game.png")
const CITADEL = preload("res://assets/citadel_game.png")
const AQUEDUCT = preload("res://assets/aqueduct_game.png")
const OBSERVATORY = preload("res://assets/observatory_game.png")
const SALT_CATHEDRAL = preload("res://assets/salt_cathedral_game.png")
const CLOCK_TOWER = preload("res://assets/clock_tower_game.png")
const FORGE_BRIDGE = preload("res://assets/forge_bridge_game.png")
const INFIRMARY = preload("res://assets/infirmary_game.png")
const RAVEN_CLOISTER = preload("res://assets/raven_cloister_game.png")
const PRISM_VAULT = preload("res://assets/prism_vault_game.png")
const FURNACE = preload("res://assets/furnace_game.png")
const ASH_COURIER = preload("res://assets/ash_courier_game.png")
const MIRROR_HOUND = preload("res://assets/mirror_hound_game.png")
const PLAGUE_SCRIBE = preload("res://assets/plague_scribe_game.png")
const RUST_CHOIR = preload("res://assets/rust_choir_game.png")
const CLOCK_WISP = preload("res://assets/clock_wisp_game.png")
const SHARD_COLLECTOR = preload("res://assets/shard_collector_game.png")
const BOSS_GREENHOUSE = preload("res://assets/boss_greenhouse_game.png")
const BOSS_GLASS = preload("res://assets/boss_glass_game.png")
const BOSS_FACELESS = preload("res://assets/boss_faceless_game.png")
const BELL_KING = preload("res://assets/bell_king_game.png")
const FUNGAL_QUEEN = preload("res://assets/fungal_queen_game.png")
const CLOCK_KNIGHT = preload("res://assets/clock_knight_game.png")
const ASH_ORACLE = preload("res://assets/ash_oracle_game.png")
const SALT_GIANT = preload("res://assets/salt_giant_game.png")
const AQUEDUCT_SERPENT = preload("res://assets/aqueduct_serpent_game.png")
const STAR_REVENANT = preload("res://assets/star_revenant_game.png")
const FORGE_WIDOW = preload("res://assets/forge_widow_game.png")
const HANDS = preload("res://assets/hands_game.png")
const BACKGROUNDS = [CORRIDOR, GREENHOUSE, GLASSWORKS, ARCHIVES, CITADEL, AQUEDUCT, OBSERVATORY, SALT_CATHEDRAL, CLOCK_TOWER, FORGE_BRIDGE, INFIRMARY, RAVEN_CLOISTER, PRISM_VAULT]
const MENU_ACCENTS = [Color("d2a465"), Color("a7c57a"), Color("8fcad0"), Color("b7a2cd"), Color("d89a85"), Color("83cec0"), Color("b9a9db"), Color("d3c3a0"), Color("e89b79"), Color("ea8e72"), Color("a5d4db"), Color("aabbd4"), Color("b6a5e7")]
const ENEMY_SPRITES = [FURNACE, ASH_COURIER, BOSS_GREENHOUSE, MIRROR_HOUND, PLAGUE_SCRIBE, BOSS_GLASS, RUST_CHOIR, CLOCK_WISP, SHARD_COLLECTOR, BOSS_FACELESS, BELL_KING, FUNGAL_QUEEN, CLOCK_KNIGHT, ASH_ORACLE, SALT_GIANT, AQUEDUCT_SERPENT, STAR_REVENANT, FORGE_WIDOW]
const W := 480.0
const H := 854.0
const GOLD := Color("e7bd6b")
const CREAM := Color("f1e5c9")
const DIM := Color("aa9e88")
const BLACK := Color("101210")
const PANEL := Color("101614")
const RED := Color("da6964")
const BLUE := Color("73bfcb")
const GREEN := Color("a5ba75")

var model = RunModel.new()
var profile = Profile.new()
var avatar_textures: Array = []
var item_icons := {}
const AVATARS = ["apprentice", "ember", "frost", "storm", "herbalist", "glass", "raven", "plague", "clock", "eclipse"]
var language := "ru"
var sound_on := true
var music_on := true
var vibration_on := true
var left_ingredient := 0
var right_ingredient := 1
var active_hand := 0
var overlay := ""
var previous_phase := "menu"
var touch_origin := Vector2.ZERO
var touch_active := false
var toast := ""
var toast_time := 0.0
var flash_time := 0.0
var impact_time := 0.0
var float_number := ""
var float_time := 0.0
var player_records: Array = []
var book_page := 0
var shop_page := 0
var tutorial_shown := false
var tutorial_stage := -1
var pulse := 0.0
var last_recipe := "01"
var effect_time := 0.0
var cast_anim_time := 0.0
var recoil_time := 0.0
var spawn_visual_time := 0.0
var shake_time := 0.0
var last_rendered_enemy := -1
var autosave_time := 0.0
var nickname_input: LineEdit
var font: Font
var music_player: AudioStreamPlayer
var music_next_player: AudioStreamPlayer
var effect_players: Array[AudioStreamPlayer] = []
var music_track := ""
var music_fade := 1.0
var last_boss_intro_round := -1
var last_menu_location := 0

func _ready() -> void:
	font = ThemeDB.fallback_font
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_load_settings()
	_load_profile()
	for avatar_name in AVATARS:
		avatar_textures.append(load("res://assets/avatar_%s.png" % avatar_name))
	for item in Profile.ITEMS:
		item_icons[item.id] = load("res://assets/item_%s.png" % item.id)
	nickname_input = LineEdit.new()
	nickname_input.placeholder_text = "Имя алхимика"
	nickname_input.max_length = 20
	nickname_input.text = profile.nickname
	nickname_input.position = Vector2(50, 300)
	nickname_input.size = Vector2(370, 38)
	nickname_input.visible = false
	nickname_input.text_submitted.connect(_nickname_committed)
	nickname_input.focus_exited.connect(_nickname_focus_lost)
	add_child(nickname_input)
	model.event.connect(_on_game_event)
	model.phase_changed.connect(_on_phase_changed)
	_build_audio()
	queue_redraw()

func _process(delta: float) -> void:
	pulse += delta
	model.advance(minf(delta, 0.1))
	toast_time = maxf(0.0, toast_time - delta)
	flash_time = maxf(0.0, flash_time - delta)
	impact_time = maxf(0.0, impact_time - delta)
	float_time = maxf(0.0, float_time - delta)
	effect_time = maxf(0.0, effect_time - delta)
	cast_anim_time = maxf(0.0, cast_anim_time - delta)
	recoil_time = maxf(0.0, recoil_time - delta)
	spawn_visual_time = maxf(0.0, spawn_visual_time - delta)
	shake_time = maxf(0.0, shake_time - delta)
	_update_music(delta)
	if nickname_input.visible and overlay != "profile": _nickname_committed(nickname_input.text)
	if nickname_input.visible:
		var canvas := _safe_canvas()
		var s: float = minf(canvas.size.x / W, canvas.size.y / H)
		var offset: Vector2 = canvas.position + (canvas.size - Vector2(W, H) * s) * 0.5
		nickname_input.position = offset + Vector2(50, 300) * s
		nickname_input.size = Vector2(370, 38) * s
	if model.phase == "combat":
		autosave_time += delta
		if autosave_time >= 5.0:
			autosave_time = 0.0
			_save_run()
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), BLACK)
	var canvas := _safe_canvas()
	var scale_value: float = minf(canvas.size.x / W, canvas.size.y / H)
	var offset: Vector2 = canvas.position + (canvas.size - Vector2(W, H) * scale_value) * 0.5
	draw_set_transform(offset, 0.0, Vector2(scale_value, scale_value))
	_draw_world()
	match model.phase:
		"menu": _draw_menu()
		"intro": _draw_intro()
		"combat": _draw_combat()
		"reward": _draw_reward()
		"boss_victory": _draw_boss_victory()
		"round_clear": _draw_round_clear()
		"dead", "won": _draw_result()
	if overlay == "settings": _draw_settings()
	elif overlay == "book": _draw_book()
	elif overlay == "pause": _draw_pause()
	elif overlay == "profile": _draw_profile()
	elif overlay == "shop": _draw_shop()
	elif overlay == "class": _draw_class_select()
	elif overlay == "reset": _draw_reset()
	elif overlay == "language_list": _draw_language_list()
	elif overlay == "tutorial": _draw_tutorial()
	elif overlay == "milestone": _draw_milestone()
	draw_set_transform(Vector2.ZERO)

func _draw_world() -> void:
	var drift := sin(pulse * 4.0) * 3.0 if model.phase == "combat" else 0.0
	var shake := sin(pulse * 49.0) * 8.0 * pow(shake_time / 0.28, 2.0) if shake_time > 0.0 else 0.0
	var scene_index: int = _menu_location() if model.phase == "menu" else model.location_index
	draw_texture_rect(BACKGROUNDS[scene_index], Rect2(-8 + shake, -8 + drift, 496, 870), false)
	if model.phase == "menu":
		var transition := smoothstep(7.2, 9.0, fposmod(pulse, 9.0))
		if transition > 0.0:
			draw_texture_rect(BACKGROUNDS[(scene_index + 1) % BACKGROUNDS.size()], Rect2(-8, -8, 496, 870), false, Color(1, 1, 1, transition))
	draw_rect(Rect2(0, 0, W, H), Color(0.015, 0.018, 0.013, 0.25))
	draw_rect(Rect2(0, 0, W, 94), Color(0.0, 0.0, 0.0, 0.5))
	if model.phase in ["combat", "reward", "paused", "boss_victory", "round_clear"]:
		var bob := sin(pulse * 5.2) * 5.0 if model.phase == "combat" else 0.0
		var arrival := 1.0 - pow(1.0 - clampf(1.0 - spawn_visual_time / 0.45, 0.0, 1.0), 3.0)
		var recoil := sin(PI * (1.0 - recoil_time / 0.24)) * 13.0 if recoil_time > 0.0 else 0.0
		var size_factor := 1.12 if model.is_boss_type(model.enemy_type) else (0.90 if model.enemy_type in [1, 7] else 1.0)
		var death_scale := 0.85 + 0.15 * clampf(model.victory_time / 2.0, 0, 1) if model.phase == "boss_victory" else 1.0
		var enemy_width := 240.0 * size_factor * death_scale * (0.86 + arrival * 0.14)
		var enemy_height := 235.0 * size_factor * death_scale * (0.86 + arrival * 0.14)
		var sprite_y := 192.0 if model.is_boss_type(model.enemy_type) else 240.0
		var sprite_rect := Rect2((W - enemy_width) * 0.5 + shake, sprite_y - (enemy_height - 235.0) * 0.22 + bob - recoil + (1.0-arrival)*36.0, enemy_width, enemy_height)
		var tint: Color = [Color.WHITE, Color("ccc2a4"), Color.WHITE, Color("b8cad6"), Color("aad3ad"), Color.WHITE, Color("d8ada5"), Color("b8d9dd"), Color("d4c3a4"), Color.WHITE, Color("dec18c"), Color("b5c494"), Color("e8a774"), Color("d6bd9c"), Color("ddd7c8"), Color("9fcfc9"), Color("c2b5d5"), Color("e98a74")][model.enemy_type]
		if model.slow_time > 0: tint = tint.lerp(Color("9fdced"), 0.45)
		if flash_time > 0: tint = Catalog.color(Catalog.ingredient_index(last_recipe[0])).lerp(Catalog.color(Catalog.ingredient_index(last_recipe[1])), 0.5)
		if model.phase == "boss_victory": tint.a = clampf(model.victory_time / 1.2, 0.0, 1.0)
		elif model.phase == "round_clear": tint.a = clampf(model.round_clear_time / 1.35, 0.0, 1.0)
		else: tint.a = 0.4 + 0.6 * arrival
		if model.is_boss_type(model.enemy_type):
			draw_texture_rect(ENEMY_SPRITES[model.enemy_type], sprite_rect.grow(4), false, Color(0.015, 0.014, 0.012, tint.a * 0.72))
		draw_texture_rect(ENEMY_SPRITES[model.enemy_type], sprite_rect, false, tint)
		_draw_enemy_effects(Vector2(240, 365 + bob))
		if model.phase == "combat" or model.phase == "paused":
			var hand_lift := sin(PI * (1.0 - cast_anim_time / 0.32)) * 26.0 if cast_anim_time > 0.0 else 0.0
			var glove_tints := [Color("ffd5b5"), Color("b9d8ec"), Color("d9ccff"), Color("c9e7c4"), Color("d8b8e8")]
			var glove_color: Color = glove_tints[model.class_id]
			if profile.golden_class_id == model.class_id: glove_color = glove_color.lerp(GOLD, 0.42)
			draw_texture_rect(HANDS, Rect2(-20 + model.lane * 7 + shake * 0.5, 286 + drift - hand_lift, 520, 347), false, glove_color)
			_draw_cuff_emblem(Vector2(48, 466 - hand_lift), glove_color)
			_draw_cuff_emblem(Vector2(432, 466 - hand_lift), glove_color)
			_draw_flask_glows()
			for lane_index in range(-1, 2):
				var marker_x := 240.0 + lane_index * 104.0
				var marker_color := RED if model.locked and lane_index == model.target_lane else (GOLD if lane_index == model.lane else Color("68685b"))
				draw_circle(Vector2(marker_x, 509), 7.0 if lane_index == model.lane else 4.0, marker_color)
			if model.locked:
				var lane_x := 240.0 + float(model.target_lane) * 104.0
				draw_colored_polygon(PackedVector2Array([Vector2(lane_x-45, 449), Vector2(lane_x+45, 449), Vector2(lane_x+77, 510), Vector2(lane_x-77, 510)]), Color(0.95, 0.15, 0.10, 0.24 + 0.12 * sin(pulse * 17.0)))
				draw_line(Vector2(lane_x-74, 506), Vector2(lane_x+74, 506), RED, 4)
	if impact_time > 0:
		draw_rect(Rect2(0, 0, W, H), Color(0.9, 0.2, 0.13, impact_time * 0.5))
	_draw_frame()

func _draw_cuff_emblem(center: Vector2, color: Color) -> void:
	draw_circle(center, 23, Color(0.025, 0.025, 0.025, 0.78))
	draw_arc(center, 21, 0, TAU, 24, color, 3.0)
	match model.class_id:
		0:
			draw_colored_polygon(PackedVector2Array([center + Vector2(-9, 10), center + Vector2(-2, -13), center + Vector2(3, -4), center + Vector2(9, 10)]), color)
		1:
			for i in range(6):
				var spoke := Vector2.RIGHT.rotated(float(i) * TAU / 6.0)
				draw_line(center + spoke * 3.0, center + spoke * 14.0, color, 2.0)
		2:
			draw_polyline(PackedVector2Array([center + Vector2(-10, -8), center + Vector2(-2, -1), center + Vector2(-5, 2), center + Vector2(9, 11)]), color, 3.0)
		3:
			draw_colored_polygon(PackedVector2Array([center + Vector2(0, -12), center + Vector2(10, 0), center + Vector2(0, 12), center + Vector2(-10, 0)]), color)
		4:
			draw_arc(center, 11, PI * 0.15, PI * 0.85, 18, color, 3.0)
			draw_circle(center, 4, color)

func _draw_intro() -> void:
	var progress := clampf(1.0 - model.intro_time / 2.2, 0.0, 1.0)
	draw_rect(Rect2(0, 0, W, H), Color(0.005, 0.007, 0.006, 0.82 - 0.18 * progress))
	_panel(Rect2(23, 334, 434, 186))
	_label(t("place_sub") + "  %02d / %02d" % [model.location_index + 1, BACKGROUNDS.size()], 42, 378, 396, 13, DIM, HORIZONTAL_ALIGNMENT_CENTER)
	_fit_label(t("place%d" % model.location_index), Rect2(42, 400, 396, 47), 25, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	_line(93, 452, 387, 452, GOLD, 2)
	_bar(Rect2(93, 477, 294, 5), progress, GOLD)

func _draw_flask_glows() -> void:
	var l: Color = Catalog.color(left_ingredient)
	var r: Color = Catalog.color(right_ingredient)
	var hand_lift := sin(PI * (1.0 - cast_anim_time / 0.32)) * 26.0 if cast_anim_time > 0.0 else 0.0
	draw_circle(Vector2(130 + model.lane * 7, 432 - hand_lift), 29, Color(l.r, l.g, l.b, 0.27))
	draw_circle(Vector2(350 + model.lane * 7, 432 - hand_lift), 29, Color(r.r, r.g, r.b, 0.27))
	draw_arc(Vector2(130 + model.lane * 7, 432 - hand_lift), 32, 0, TAU, 28, l, 2.0)
	draw_arc(Vector2(350 + model.lane * 7, 432 - hand_lift), 32, 0, TAU, 28, r, 2.0)

func _draw_enemy_effects(center: Vector2) -> void:
	if model.burn_time > 0:
		for i in range(9):
			var x := center.x + sin(pulse * 2.0 + i * 2.31) * (38 + i * 5)
			var y := center.y + 90 - fposmod(pulse * (38 + i * 6) + i * 19, 165)
			draw_colored_polygon(PackedVector2Array([Vector2(x-5,y+9),Vector2(x+5,y+9),Vector2(x,y-12)]), Color("f58d3d") if i % 2 else Color("f0d262"))
	if model.slow_time > 0:
		for i in range(7):
			var angle := pulse * 0.4 + i * TAU / 7.0
			var p := center + Vector2(cos(angle) * 76, sin(angle) * 78)
			draw_line(p + Vector2(-8,0), p + Vector2(8,0), Color("b2eff5"), 2)
			draw_line(p + Vector2(0,-8), p + Vector2(0,8), Color("b2eff5"), 2)
	if model.enemy_poison_time > 0:
		for i in range(7):
			var x := center.x + sin(pulse * 1.9 + i * 1.77) * (29 + i * 6)
			var y := center.y + 96 - fposmod(pulse * 25.0 + i * 28.0, 190.0)
			draw_circle(Vector2(x, y), 3.0 + float(i % 3), Color("a2d889"))
	if model.shield > 0:
		var shield_color := Color(0.55, 0.89, 0.78, 0.32 + 0.09 * sin(pulse * 3.0))
		draw_arc(Vector2(240, 480), 92, PI * 1.1, PI * 1.9, 32, shield_color, 4)
	if effect_time > 0:
		var blend: Color = Catalog.color(Catalog.ingredient_index(last_recipe[0])).lerp(Catalog.color(Catalog.ingredient_index(last_recipe[1])), 0.5)
		var variant := Catalog.ingredient_index(last_recipe[0]) * Catalog.INGREDIENTS.size() + Catalog.ingredient_index(last_recipe[1])
		for i in range(8 + variant % 5):
			var a := float(i) * TAU / float(8 + variant % 5) + variant * 0.37
			var dist := (1.0 - effect_time / 0.7) * (55 + variant % 4 * 11)
			var p := center + Vector2(cos(a), sin(a)) * dist
			if variant % 3 == 0: draw_circle(p, 3 + variant % 4, blend)
			elif variant % 3 == 1: draw_rect(Rect2(p-Vector2(4,4), Vector2(8,8)), blend)
			else: draw_line(p-Vector2(5,5), p+Vector2(5,5), blend, 3)

func _draw_frame() -> void:
	draw_rect(Rect2(10, 10, 460, 834), Color(0.8, 0.58, 0.28, 0.38), false, 2)
	draw_line(Vector2(21, 21), Vector2(58, 21), GOLD, 3)
	draw_line(Vector2(21, 21), Vector2(21, 58), GOLD, 3)
	draw_line(Vector2(459, 833), Vector2(422, 833), GOLD, 3)
	draw_line(Vector2(459, 833), Vector2(459, 796), GOLD, 3)

func _draw_menu() -> void:
	var accent := _menu_accent()
	draw_rect(Rect2(0, 0, W, H), Color(0.015, 0.02, 0.014, 0.62))
	draw_circle(Vector2(240, 139), 29, Color(0.06, 0.07, 0.055, 0.94))
	draw_arc(Vector2(240, 139), 29, 0, TAU, 40, accent, 2.0)
	draw_colored_polygon(PackedVector2Array([Vector2(240, 120), Vector2(251, 139), Vector2(240, 158), Vector2(229, 139)]), accent)
	_fit_label(t("title"), Rect2(28, 187, 424, 43), 27, CREAM, HORIZONTAL_ALIGNMENT_CENTER)
	_line(118, 240, 362, 240, accent, 2)
	_label(t("subtitle"), 35, 268, 410, 12, DIM, HORIZONTAL_ALIGNMENT_CENTER)
	_label("VI · ALCHEMIA · MMXXVI", 30, 309, 420, 12, accent, HORIZONTAL_ALIGNMENT_CENTER)
	_menu_plaque(Rect2(56, 357, 368, 62), t("continue_run"), 0, accent, FileAccess.file_exists("user://run.cfg"), not FileAccess.file_exists("user://run.cfg"))
	_menu_plaque(Rect2(56, 431, 368, 62), t("new_run") + "  ·  %d" % mini(100, 10 * (profile.completed_runs + 1)), 1, accent, true)
	_menu_plaque(Rect2(56, 505, 178, 56), t("profile"), 2, accent)
	_menu_plaque(Rect2(246, 505, 178, 56), t("shop"), 3, accent)
	_menu_plaque(Rect2(56, 573, 368, 56), t("book"), 4, accent)
	_menu_plaque(Rect2(56, 641, 178, 56), t("tutorial"), 4, accent)
	_menu_plaque(Rect2(246, 641, 178, 56), t("settings"), 5, accent)
	_fit_label(t("place%d" % _menu_location()), Rect2(50, 753, 380, 28), 13, accent, HORIZONTAL_ALIGNMENT_CENTER)

func _menu_location() -> int:
	return (last_menu_location + int(floor(pulse / 9.0))) % BACKGROUNDS.size()

func _menu_accent() -> Color:
	var index := _menu_location()
	return MENU_ACCENTS[index].lerp(MENU_ACCENTS[(index + 1) % MENU_ACCENTS.size()], smoothstep(7.2, 9.0, fposmod(pulse, 9.0)))

func _menu_plaque(rect: Rect2, title: String, icon: int, accent: Color, primary: bool = false, muted: bool = false) -> void:
	var x := rect.position.x
	var y := rect.position.y
	var w := rect.size.x
	var h := rect.size.y
	var corners := PackedVector2Array([Vector2(x+12,y),Vector2(x+w-12,y),Vector2(x+w,y+12),Vector2(x+w,y+h-12),Vector2(x+w-12,y+h),Vector2(x+12,y+h),Vector2(x,y+h-12),Vector2(x,y+12)])
	draw_colored_polygon(corners, Color(0.07, 0.09, 0.075, 0.96) if not primary else Color(0.17, 0.17, 0.11, 0.97))
	for i in range(corners.size()): draw_line(corners[i], corners[(i+1)%corners.size()], accent if primary else accent.darkened(0.28), 2.0)
	draw_circle(Vector2(x+31, y+h*0.5), 17, Color(0.02, 0.03, 0.025, 1))
	draw_arc(Vector2(x+31, y+h*0.5), 17, 0, TAU, 24, accent, 2.0)
	var center := Vector2(x+31, y+h*0.5)
	match icon:
		0: draw_colored_polygon(PackedVector2Array([center+Vector2(-5,-8),center+Vector2(8,0),center+Vector2(-5,8)]), accent)
		1:
			draw_line(center+Vector2(-8,0),center+Vector2(8,0),accent,3)
			draw_line(center+Vector2(0,-8),center+Vector2(0,8),accent,3)
		2:
			draw_circle(center+Vector2(0,-5),4,accent)
			draw_arc(center+Vector2(0,8),7,PI,TAU,12,accent,2)
		3: draw_colored_polygon(PackedVector2Array([center+Vector2(0,-9),center+Vector2(9,0),center+Vector2(0,9),center+Vector2(-9,0)]), accent)
		4:
			draw_line(center+Vector2(-8,-8),center+Vector2(-8,8),accent,2)
			draw_line(center+Vector2(-6,-7),center+Vector2(1,-4),accent,2)
			draw_line(center+Vector2(1,-4),center+Vector2(8,-7),accent,2)
			draw_line(center+Vector2(8,-7),center+Vector2(8,8),accent,2)
		5:
			draw_circle(center,6,accent)
			draw_circle(center,3,Color("101614"))
	var label_color := DIM if muted else CREAM
	_fit_label(title, Rect2(x+60, y+9, w-73, h-18), 15, label_color, HORIZONTAL_ALIGNMENT_CENTER)

func _draw_combat() -> void:
	_panel(Rect2(22, 23, 436, 77))
	_fit_label("%s  %02d / %02d" % [t("wave"), model.kills + 1, model.run_goal], Rect2(35, 32, 210, 20), 14, GOLD)
	_fit_label(t("level") + " %d" % model.player_level, Rect2(277, 32, 112, 20), 11, GOLD, HORIZONTAL_ALIGNMENT_RIGHT)
	_label("Ⅱ", 415, 53, 32, 22, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	_label("HP", 35, 77, 26, 11, CREAM)
	_bar(Rect2(65, 66, 128, 11), model.hp / model.max_hp, RED)
	_label("%d" % int(ceilf(model.hp)), 195, 77, 33, 11, CREAM, HORIZONTAL_ALIGNMENT_RIGHT)
	_label("MP", 247, 77, 26, 11, CREAM)
	_bar(Rect2(278, 66, 126, 11), model.mana / model.max_mana, BLUE)
	_label("%d" % int(ceilf(model.mana)), 405, 77, 34, 11, CREAM, HORIZONTAL_ALIGNMENT_RIGHT)
	_fit_label(t("enemy%d" % model.enemy_type), Rect2(44, 128, 392, 27), 18, CREAM, HORIZONTAL_ALIGNMENT_CENTER)
	if model.is_boss_type(model.enemy_type):
		_fit_label(t("boss") + "  •  " + t("level") + " %d" % model.player_level, Rect2(127, 156, 226, 18), 11, RED, HORIZONTAL_ALIGNMENT_CENTER)
	else:
		_fit_label(t("trait_" + str(model.ENEMIES[model.enemy_type].trait)), Rect2(122, 156, 236, 18), 10, DIM, HORIZONTAL_ALIGNMENT_CENTER)
	_bar(Rect2(91, 180, 298, 10), model.enemy_hp / model.enemy_max, RED)
	if model.armor > 0:
		_label("◈ %d" % int(model.armor), 350, 176, 38, 12, DIM, HORIZONTAL_ALIGNMENT_RIGHT)
	if model.burn_time > 0 or model.slow_time > 0:
		var status := ("▲ " + t("burn") if model.burn_time > 0 else "") + ("    ✧ " + t("slow") if model.slow_time > 0 else "")
		_fit_label(status, Rect2(135, 207, 210, 17), 11, Color("f0bd84") if model.burn_time > 0 else Color("b2eff5"), HORIZONTAL_ALIGNMENT_CENTER)
	if model.locked:
		_label("!", 224, 232, 32, 35, RED, HORIZONTAL_ALIGNMENT_CENTER)
	else:
		_bar(Rect2(167, 202, 146, 3), model.attack_time / model.enemy_interval, GOLD)
	if float_time > 0:
		_label(float_number, 130, 286 - (1.0 - float_time) * 42, 220, 30, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	if toast_time > 0:
		_panel(Rect2(43, 520, 394, 31))
		_fit_label(toast, Rect2(51, 523, 378, 24), 11, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	_draw_deck()

func _draw_deck() -> void:
	_panel(Rect2(19, 557, 442, 284))
	var r: Dictionary = Catalog.recipe(left_ingredient, right_ingredient)
	var ready: bool = model.mana >= ceilf(r.cost * model.cost_bonus)
	_draw_hand_slot(Rect2(31, 566, 203, 58), 0, left_ingredient)
	_draw_hand_slot(Rect2(246, 566, 203, 58), 1, right_ingredient)
	_label(t("preview"), 35, 644, 122, 10, DIM)
	var recipe_name := t(r.key)
	if r.compound: recipe_name = t(Catalog.INGREDIENTS[Catalog.ingredient_index(r.id[0])].key + "_short") + " + " + t(Catalog.INGREDIENTS[Catalog.ingredient_index(r.id[1])].key + "_short")
	_fit_label(recipe_name, Rect2(155, 630, 280, 20), 17, GOLD, HORIZONTAL_ALIGNMENT_RIGHT)
	var preview_damage := maxf(4.0, r.damage * model.damage_bonus * (1.0 + model.evasion_bonus) - (0.0 if r.pierce else model.armor))
	var effects := "%s %d" % [t("damage"), int(ceilf(preview_damage))]
	if r.burn > 0: effects += "  ·  " + t("burn")
	if r.slow > 0: effects += "  ·  " + t("slow")
	if r.pierce: effects += "  ·  " + t("pierce")
	if r.heal > 0: effects += "  ·  " + t("heal_effect")
	if r.stagger > 0: effects += "  ·  " + t("stagger")
	if r.corrode > 0: effects += "  ·  " + t("corrode")
	if r.mana_return > 0: effects += "  ·  " + t("mana_return")
	if r.poison > 0: effects += "  ·  " + t("poison_effect")
	if r.shield > 0: effects += "  ·  " + t("shield_effect")
	if model.evasion_bonus > 0.0: effects += "  ·  +%d%%" % int(round(model.evasion_bonus * 100.0))
	_fit_label(effects, Rect2(34, 648, 410, 24), 12, CREAM, HORIZONTAL_ALIGNMENT_CENTER)
	var loadout: Array = Catalog.CLASS_LOADOUTS[model.class_id]
	for i in range(4):
		var ingredient: int = loadout[i]
		var rect := Rect2(32 + i * 105, 699, 99, 71)
		var selected := ingredient == (left_ingredient if active_hand == 0 else right_ingredient)
		var color: Color = Catalog.color(ingredient)
		draw_rect(rect, Color("1c2521"))
		draw_rect(rect, color if selected else Color("696756"), false, 2 if selected else 1)
		draw_rect(Rect2(rect.position.x + 5, rect.position.y + 6, 5, 59), color)
		_label(Catalog.INGREDIENTS[ingredient].mark, rect.position.x + 15, rect.position.y + 26, 75, 13, color)
		_fit_label(t(Catalog.INGREDIENTS[ingredient].key + "_short"), Rect2(rect.position.x + 12, rect.position.y + 31, 76, 33), 11, CREAM, HORIZONTAL_ALIGNMENT_CENTER)
	if tutorial_stage >= 0:
		_panel(Rect2(29, 513, 422, 40))
		_fit_label(t("tutorial_step_%d" % tutorial_stage), Rect2(40, 520, 400, 23), 12, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	_button(Rect2(32, 790, 416, 45), "%s  • %d" % [t("cast"), int(ceilf(r.cost * model.cost_bonus))], ready, not ready)

func _draw_hand_slot(rect: Rect2, hand: int, ingredient: int) -> void:
	var active := hand == active_hand
	var color: Color = Catalog.color(ingredient)
	draw_rect(rect, Color("2a291f") if active else PANEL)
	draw_rect(rect, GOLD if active else Color("817255"), false, 2 if active else 1)
	draw_rect(Rect2(rect.position.x + 6, rect.position.y + 7, 6, rect.size.y - 14), color)
	var ordinal := "01" if hand == 0 else "02"
	_label(ordinal + "  " + t("left" if hand == 0 else "right"), rect.position.x + 20, rect.position.y + 20, rect.size.x - 29, 11, GOLD if active else DIM)
	_fit_label(t(Catalog.INGREDIENTS[ingredient].key), Rect2(rect.position.x + 20, rect.position.y + 25, rect.size.x - 28, 24), 14, CREAM)
	if active: draw_rect(Rect2(rect.position.x, rect.position.y + rect.size.y - 3, rect.size.x, 3), GOLD)

func _draw_reward() -> void:
	draw_rect(Rect2(0, 0, W, H), Color(0, 0, 0, 0.82))
	_panel(Rect2(29, 213, 422, 427))
	_fit_label(t("reward"), Rect2(42, 245, 396, 37), 25, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	_fit_label(t("reward_sub"), Rect2(42, 284, 396, 28), 13, DIM, HORIZONTAL_ALIGNMENT_CENTER)
	for i in range(3):
		var names := ["heal", "power", "focus"]
		var key: String = names[i]
		var rect := Rect2(50, 324 + i * 95, 380, 82)
		draw_rect(rect, Color("302b1d") if i == 0 else PANEL)
		draw_rect(rect, GOLD if i == 0 else Color("7f7255"), false, 2)
		var icon_id: String = ["heart", "gloves", "vial"][i]
		draw_texture_rect(item_icons[icon_id], Rect2(rect.position.x + 13, rect.position.y + 13, 55, 55), false)
		_fit_label(t(key), Rect2(rect.position.x + 81, rect.position.y + 10, 280, 26), 16, CREAM)
		_fit_label(t(key + "_desc"), Rect2(rect.position.x + 81, rect.position.y + 44, 280, 23), 12, DIM)

func _draw_boss_victory() -> void:
	var fade := clampf(model.victory_time / 2.0, 0.0, 1.0)
	draw_rect(Rect2(0, 0, W, H), Color(0.02, 0.01, 0.008, 0.55 + (1.0 - fade) * 0.22))
	_panel(Rect2(29, 340, 422, 176))
	_label(t("boss_down"), 45, 397, 390, 25, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	_label(t("boss_reward"), 45, 435, 390, 14, CREAM, HORIZONTAL_ALIGNMENT_CENTER)
	_bar(Rect2(91, 468, 298, 5), 1.0 - fade, GOLD)

func _draw_round_clear() -> void:
	var progress := clampf(1.0 - model.round_clear_time / 1.35, 0.0, 1.0)
	draw_rect(Rect2(0, 0, W, H), Color(0.005, 0.009, 0.008, 0.25 + 0.28 * progress))
	_panel(Rect2(54, 357, 372, 124))
	_fit_label(t("enemy_down"), Rect2(69, 382, 342, 35), 23, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	_fit_label(t("next_foe"), Rect2(75, 421, 330, 24), 12, CREAM, HORIZONTAL_ALIGNMENT_CENTER)
	_bar(Rect2(88, 459, 304, 5), progress, GOLD)

func _avatar(rect: Rect2, index: int) -> void:
	if index >= 0 and index < avatar_textures.size() and avatar_textures[index] != null:
		draw_texture_rect(avatar_textures[index], rect, false)
	draw_rect(rect, GOLD if index == profile.golden_avatar_index else Color("8a795a"), false, 3 if index == profile.golden_avatar_index else 2)
	if index == profile.golden_avatar_index:
		_draw_crown(Vector2(rect.end.x - 13, rect.position.y + 11), 0.65)

func _draw_crown(center: Vector2, scale_value: float = 1.0) -> void:
	var points := PackedVector2Array([Vector2(-14, 8), Vector2(-14, -5), Vector2(-7, 1), Vector2(0, -10), Vector2(7, 1), Vector2(14, -5), Vector2(14, 8)])
	for i in range(points.size()): points[i] = center + points[i] * scale_value
	draw_colored_polygon(points, GOLD)
	draw_line(center + Vector2(-14, 10) * scale_value, center + Vector2(14, 10) * scale_value, CREAM, 3.0 * scale_value)

func _draw_profile() -> void:
	draw_rect(Rect2(0, 0, W, H), Color("0b100f"))
	_panel(Rect2(23, 52, 434, 736))
	_label(t("profile"), 42, 99, 396, 25, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	_avatar(Rect2(46, 126, 105, 105), profile.avatar_index)
	if profile.level() >= 50: _draw_crown(Vector2(409, 91), 0.85)
	_label(t("level") + " %d / 50" % profile.level(), 176, 158, 260, 18, CREAM)
	_bar(Rect2(176, 174, 249, 9), profile.xp_progress(), GOLD)
	_label(t("max_level") if profile.level() >= 50 else "XP %d / %d" % [profile.xp, Profile.threshold(profile.level() + 1)], 176, 201, 249, 12, DIM)
	_label("◈ %d" % profile.coins, 176, 226, 249, 17, GOLD)
	_fit_label(t("level_effect") + "  +%d HP  ·  +%d MP  ·  +%d%% DMG" % [int(round((profile.level() - 1) * 1.5)), int(round((profile.level() - 1) * 0.35)), int(round((profile.level() - 1) * 0.8))], Rect2(47, 236, 382, 24), 11, GREEN)
	_label(t("nickname"), 49, 278, 370, 13, DIM)
	_button(Rect2(46, 296, 378, 46), profile.nickname)
	_label(t("choose_avatar"), 49, 372, 370, 13, DIM)
	for i in range(10):
		var rect := Rect2(47 + (i % 5) * 77, 395 + (i / 5) * 73, 61, 61)
		_avatar(rect, i)
		if i == profile.avatar_index: draw_rect(rect.grow(3), GOLD, false, 2)
	_label(t("class") + ": " + t("class_" + Profile.CLASSES[profile.class_id]), 47, 548, 386, 14, CREAM)
	for i in range(Profile.SLOTS.size()):
		var slot: String = Profile.SLOTS[i]
		var item_id: String = profile.equipped[slot]
		var x := 47.0 + (i % 2) * 192.0
		var y := 564.0 + (i / 2) * 22.0
		if item_id != "" and item_icons.has(item_id): _draw_item_icon(item_id, Rect2(x, y, 19, 19))
		var equipped_text := t("item_" + item_id) + "  ·  %d/5" % profile.item_level(item_id) if item_id != "" else t("slot_" + slot) + ": —"
		_fit_label(equipped_text, Rect2(x + 20, y, 169, 19), 10, GOLD)
	if profile.has_milestone_reward():
		_button(Rect2(47, 658, 381, 34), t("milestone_reward") + "  %d" % profile.next_milestone(), true)
	_button(Rect2(47, 704, 178, 50), t("reset_profile"), false)
	_button(Rect2(241, 704, 187, 50), t("back"), true)

func _draw_shop() -> void:
	draw_rect(Rect2(0, 0, W, H), Color("0b100f"))
	_panel(Rect2(23, 43, 434, 760))
	_label(t("shop"), 43, 89, 394, 25, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	_label("◈ %d    •    %d / 5" % [profile.coins, shop_page + 1], 43, 115, 394, 16, CREAM, HORIZONTAL_ALIGNMENT_CENTER)
	if toast_time > 0: _label(toast, 43, 130, 394, 11, RED, HORIZONTAL_ALIGNMENT_CENTER)
	for i in range(4):
		var item: Dictionary = Profile.ITEMS[shop_page * 4 + i]
		var rect := Rect2(43, 151 + i * 118, 394, 108)
		var level: int = profile.item_level(item.id)
		var glow := _item_color(level)
		draw_rect(rect, PANEL)
		draw_rect(rect, glow if level > 1 else (GOLD if profile.equipped.get(item.slot, "") == item.id else Color("776a4b")), false, 2)
		if item_icons.has(item.id): _draw_item_icon(item.id, Rect2(rect.position.x + 12, rect.position.y + 16, 75, 75))
		_fit_label(t("item_" + item.id), Rect2(rect.position.x + 100, rect.position.y + 14, 192, 27), 15, CREAM)
		var description: String = t("item_" + item.id + "_desc")
		if description.contains(","):
			_fit_label(description.get_slice(",", 0).strip_edges(), Rect2(rect.position.x + 100, rect.position.y + 43, 175, 20), 12, DIM)
			_fit_label(description.get_slice(",", 1).strip_edges(), Rect2(rect.position.x + 100, rect.position.y + 61, 175, 20), 12, DIM)
		else:
			_fit_label(description, Rect2(rect.position.x + 100, rect.position.y + 51, 175, 24), 12, DIM)
		for pip in range(5):
			draw_rect(Rect2(rect.position.x + 100 + pip * 20, rect.position.y + 84, 14, 5), glow if pip < level else Color("504b3d"))
		if level > 0:
			_label("%d / 5" % level, rect.position.x + 300, rect.position.y + 35, 85, 13, glow, HORIZONTAL_ALIGNMENT_CENTER)
		var label_text := "◈ %d" % item.price if level == 0 else (t("max_level") if level == 5 else "↑ ◈%d" % profile.upgrade_cost(item.id))
		draw_rect(Rect2(rect.position.x + 289, rect.position.y + 52, 96, 38), Color("2c291d") if level > 0 else Color("302719"))
		draw_rect(Rect2(rect.position.x + 289, rect.position.y + 52, 96, 38), glow, false, 1)
		_fit_label(label_text, Rect2(rect.position.x + 294, rect.position.y + 63, 86, 18), 12, glow, HORIZONTAL_ALIGNMENT_CENTER)
	_button(Rect2(43, 686, 112, 43), "‹")
	_button(Rect2(167, 686, 146, 43), t("back"), true)
	_button(Rect2(325, 686, 112, 43), "›")
	_fit_label(t("shop_hint"), Rect2(46, 743, 388, 30), 11, DIM, HORIZONTAL_ALIGNMENT_CENTER)

func _item_color(level: int) -> Color:
	match level:
		2: return Color("80bbb6")
		3: return Color("e9be71")
		4: return Color("b6a3df")
		5: return Color("f19b73")
	return GOLD

func _draw_item_icon(id: String, rect: Rect2) -> void:
	var level := profile.item_level(id)
	if level > 1:
		var glow := _item_color(level)
		var strength := 0.10 + 0.08 * (0.5 + 0.5 * sin(pulse * 2.4))
		draw_rect(rect.grow(2), Color(glow.r, glow.g, glow.b, strength))
		draw_rect(rect.grow(2), glow, false, 1.0)
	draw_texture_rect(item_icons[id], rect, false)
	if level > 1:
		for pip in range(level - 1):
			draw_circle(Vector2(rect.position.x + 5 + pip * 7, rect.end.y - 5), 2.0, _item_color(level))

func _draw_class_select() -> void:
	draw_rect(Rect2(0, 0, W, H), Color("0b100f"))
	_panel(Rect2(23, 61, 434, 734))
	_label(t("choose_class"), 39, 105, 402, 23, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	for i in range(5):
		var y := 133 + i * 99
		var key: String = Profile.CLASSES[i]
		var rect := Rect2(43, y, 394, 89)
		draw_rect(rect, Color("2d2a20") if profile.class_id == i else PANEL)
		draw_rect(rect, GOLD if profile.class_id == i or profile.golden_class_id == i else Color("766b51"), false, 3 if profile.golden_class_id == i else 2)
		_avatar(Rect2(52, y + 11, 64, 64), i + 1)
		_fit_label(t("class_" + key), Rect2(129, y + 7, 296, 23), 15, CREAM)
		if profile.golden_class_id == i: _draw_crown(Vector2(407, y + 21), 0.55)
		_fit_label(t("class_" + key + "_desc"), Rect2(129, y + 30, 296, 27), 11, DIM)
		var ingredients: Array = Catalog.CLASS_LOADOUTS[i]
		var names := ""
		for ingredient in ingredients:
			if names != "": names += "  ·  "
			names += t(Catalog.INGREDIENTS[ingredient].key + "_short")
		_fit_label(names, Rect2(129, y + 59, 296, 22), 10, GOLD)
	_button(Rect2(43, 653, 394, 54), t("start"), true)
	_button(Rect2(43, 717, 394, 48), t("back"))

func _draw_tutorial() -> void:
	draw_rect(Rect2(0, 0, W, H), Color(0.01, 0.015, 0.012, 0.9))
	_panel(Rect2(33, 231, 414, 391))
	_fit_label(t("tutorial"), Rect2(49, 260, 382, 38), 24, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	for i in range(3):
		var step: int = [0, 2, 3][i]
		var y := 322 + i * 53
		draw_rect(Rect2(57, y, 366, 43), PANEL)
		draw_rect(Rect2(57, y, 366, 43), Color("6a5940"), false, 1)
		_label("0%d" % (i + 1), 69, y + 27, 31, 14, GOLD)
		_fit_label(t("tutorial_step_%d" % step), Rect2(105, y + 7, 308, 29), 11, CREAM)
	_button(Rect2(57, 489, 366, 53), t("start"), true)
	_button(Rect2(57, 550, 366, 45), t("back"))

func _draw_milestone() -> void:
	draw_rect(Rect2(0, 0, W, H), Color(0.0, 0.0, 0.0, 0.86))
	_panel(Rect2(31, 224, 418, 411))
	_fit_label(t("milestone_reward") + "  %d" % profile.reward_milestone, Rect2(44, 251, 392, 35), 21, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	for i in range(profile.reward_choices.size()):
		var choice: Dictionary = profile.reward_choices[i]
		var item_id := str(choice.id)
		var y := 303 + i * 94
		draw_rect(Rect2(49, y, 382, 80), PANEL)
		draw_rect(Rect2(49, y, 382, 80), GOLD, false, 2)
		_draw_item_icon(item_id, Rect2(59, y + 9, 61, 61))
		_fit_label(t("reward_item" if choice.kind == "item" else "reward_upgrade"), Rect2(131, y + 9, 284, 24), 12, GOLD)
		_fit_label(t("item_" + item_id), Rect2(131, y + 35, 284, 27), 16, CREAM)
	_button(Rect2(72, 589, 336, 36), t("back"))

func _draw_reset() -> void:
	draw_rect(Rect2(0, 0, W, H), Color(0, 0, 0, 0.91))
	_panel(Rect2(35, 273, 410, 307))
	_fit_label(t("reset_confirm"), Rect2(54, 319, 372, 80), 17, CREAM, HORIZONTAL_ALIGNMENT_CENTER)
	_button(Rect2(55, 426, 370, 54), t("reset_profile"))
	_button(Rect2(55, 495, 370, 54), t("back"), true)

func _draw_result() -> void:
	draw_rect(Rect2(0, 0, W, H), Color(0, 0, 0, 0.76))
	_panel(Rect2(35, 231, 410, 394))
	_label("✦", 0, 296, W, 38, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	_label(t("won") if model.phase == "won" else t("dead"), 48, 343, 384, 26, CREAM, HORIZONTAL_ALIGNMENT_CENTER)
	_line(102, 358, 378, 358, GOLD, 2)
	_label("%s: %d / %d" % [t("score"), model.kills, model.run_goal], 65, 400, 350, 17, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	_label("%s: %02d:%02d" % [t("time"), int(model.elapsed) / 60, int(model.elapsed) % 60], 65, 435, 350, 15, DIM, HORIZONTAL_ALIGNMENT_CENTER)
	_button(Rect2(64, 483, 352, 59), t("again"), true)
	_button(Rect2(64, 552, 352, 50), t("menu"))

func _draw_pause() -> void:
	draw_rect(Rect2(0, 0, W, H), Color(0, 0, 0, 0.78))
	_panel(Rect2(35, 267, 410, 319))
	_label(t("paused"), 60, 325, 360, 28, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	_button(Rect2(64, 363, 352, 55), t("resume"), true)
	_button(Rect2(64, 432, 352, 55), t("settings"))
	_button(Rect2(64, 501, 352, 55), t("menu"))

func _draw_settings() -> void:
	draw_rect(Rect2(0, 0, W, H), Color(0.008, 0.014, 0.012, 1.0))
	_panel(Rect2(28, 172, 424, 510))
	_label(t("settings"), 48, 221, 384, 26, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	_button(Rect2(52, 252, 376, 57), t("language") + "   ·   " + Locale.language_name(language) + "   ▾")
	_button(Rect2(52, 322, 376, 57), t("music") + "   " + t("on" if music_on else "off"))
	_button(Rect2(52, 392, 376, 57), t("audio") + "   " + t("on" if sound_on else "off"))
	_button(Rect2(52, 462, 376, 57), t("vibration") + "   " + t("on" if vibration_on else "off"))
	_button(Rect2(52, 577, 376, 59), t("back"), true)

func _draw_language_list() -> void:
	draw_rect(Rect2(0, 0, W, H), Color("090d0c"))
	_panel(Rect2(23, 80, 434, 682))
	_fit_label(t("language"), Rect2(40, 109, 400, 35), 23, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	for i in range(Locale.LANGUAGES.size()):
		var item: Dictionary = Locale.LANGUAGES[i]
		var rect := Rect2(42 + (i % 2) * 202, 159 + (i / 2) * 58, 194, 51)
		draw_rect(rect, Color("302a1a") if item.code == language else PANEL)
		draw_rect(rect, GOLD if item.code == language else Color("756b53"), false, 2)
		_fit_label(item.name, rect.grow(-7), 15, CREAM, HORIZONTAL_ALIGNMENT_CENTER)
	_button(Rect2(54, 678, 372, 54), t("back"), true)

func _draw_book() -> void:
	draw_rect(Rect2(0, 0, W, H), Color(0.008, 0.014, 0.012, 1.0))
	_panel(Rect2(23, 116, 434, 622))
	_label(t("book"), 41, 166, 398, 24, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	_label("%d / 78    •    %d / %d" % [model.discovered.size(), book_page + 1, maxi(1, ceili(model.discovered.size() / 14.0))], 49, 200, 382, 13, DIM, HORIZONTAL_ALIGNMENT_CENTER)
	if model.discovered.is_empty():
		_label(t("book_empty"), 43, 324, 394, 14, DIM, HORIZONTAL_ALIGNMENT_CENTER)
	else:
		for i in range(14):
			var position := book_page * 14 + i
			if position >= model.discovered.size(): break
			var id: String = model.discovered[position]
			var left_index := Catalog.ingredient_index(id[0])
			var right_index := Catalog.ingredient_index(id[1])
			var r: Dictionary = Catalog.recipe(left_index, right_index)
			var x := 46.0 + (i % 2) * 196.0
			var y := 238.0 + (i / 2) * 54.0
			draw_rect(Rect2(x, y, 188, 47), PANEL)
			draw_rect(Rect2(x, y, 188, 47), Color("6f674b"), false, 1)
			_fit_label(t(r.key) if not r.compound else t("new_mix"), Rect2(x + 8, y + 5, 174, 18), 11, CREAM)
			_label("%s + %s" % [Catalog.INGREDIENTS[left_index].mark, Catalog.INGREDIENTS[right_index].mark], x + 8, y + 38, 174, 11, GOLD)
	_button(Rect2(53, 655, 75, 57), "‹")
	_button(Rect2(143, 655, 194, 57), t("back"), true)
	_button(Rect2(352, 655, 75, 57), "›")

func _panel(rect: Rect2) -> void:
	draw_rect(rect, Color(0.025, 0.035, 0.03, 0.94))
	draw_rect(rect, Color("776a4b"), false, 2)
	draw_line(rect.position + Vector2(7, 7), rect.position + Vector2(43, 7), GOLD, 2)

func _button(rect: Rect2, title: String, primary: bool = false, muted: bool = false) -> void:
	draw_rect(rect, Color("312b1a") if primary else PANEL)
	draw_rect(rect, GOLD if primary else Color("736b55"), false, 2)
	draw_rect(Rect2(rect.position.x + 4, rect.position.y + 4, 3, rect.size.y - 8), GOLD if primary else DIM)
	_fit_label(title, Rect2(rect.position.x + 12, rect.position.y + 7, rect.size.x - 24, rect.size.y - 14), 15 if rect.size.x > 200 else 13, DIM if muted else CREAM, HORIZONTAL_ALIGNMENT_CENTER)

func _bar(rect: Rect2, value: float, fill: Color) -> void:
	draw_rect(rect, Color("100e0f"))
	draw_rect(Rect2(rect.position, Vector2(rect.size.x * clampf(value, 0, 1), rect.size.y)), fill)
	draw_rect(rect, Color("aaa17e"), false, 1)

func _label(value: String, x: float, baseline: float, width: float, size_px: int, color: Color, align: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> void:
	draw_string(font, Vector2(x, baseline), value, align, width, size_px, color)

func _fit_label(value: String, rect: Rect2, preferred: int, color: Color, align: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> void:
	var font_size := preferred
	while font_size > 9 and font.get_string_size(value, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > rect.size.x:
		font_size -= 1
	_label(value, rect.position.x, rect.position.y + rect.size.y * 0.69, rect.size.x, font_size, color, align)

func _line(x1: float, y1: float, x2: float, y2: float, color: Color, thick: float) -> void:
	draw_line(Vector2(x1, y1), Vector2(x2, y2), color, thick)

func t(key: String) -> String:
	return Locale.get_text(language, key)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			touch_origin = _to_design(event.position)
			touch_active = true
		elif touch_active:
			_handle_release(_to_design(event.position))
	elif event is InputEventScreenTouch:
		if event.pressed:
			touch_origin = _to_design(event.position)
			touch_active = true
		elif touch_active:
			_handle_release(_to_design(event.position))
	elif event is InputEventKey and event.pressed and not event.echo:
		_handle_key(event.keycode)

func _to_design(point: Vector2) -> Vector2:
	var canvas := _safe_canvas()
	var s: float = minf(canvas.size.x / W, canvas.size.y / H)
	return (point - canvas.position - (canvas.size - Vector2(W, H) * s) * 0.5) / s

func _safe_canvas() -> Rect2:
	var canvas := Rect2(Vector2.ZERO, size)
	if OS.has_feature("ios"):
		var safe := DisplayServer.get_display_safe_area()
		var screen := DisplayServer.screen_get_size()
		if safe.size.x > 0 and safe.size.y > 0 and screen.x > 0 and screen.y > 0:
			var ratio_pos := Vector2(safe.position) / Vector2(screen)
			var ratio_size := Vector2(safe.size) / Vector2(screen)
			canvas = Rect2(ratio_pos * size, ratio_size * size)
	return canvas

func _handle_release(point: Vector2) -> void:
	touch_active = false
	var movement := point - touch_origin
	if model.phase == "combat" and overlay == "" and movement.length() > 42:
		if touch_origin.y >= 495 and touch_origin.y <= 640 and point.y >= 495 and point.y <= 670 and ((touch_origin.x < 238 and point.x > 242) or (touch_origin.x > 242 and point.x < 238)):
			_cast()
			return
		elif absf(movement.x) > absf(movement.y) and touch_origin.y < 670:
			if tutorial_stage < 0 or tutorial_stage >= 3: model.dodge(1 if movement.x > 0 else -1)
			return
		elif movement.y < -60 and touch_origin.y > 500:
			_cast()
			return
	_handle_tap(point)

func _hit(point: Vector2, x: float, y: float, w: float, h: float) -> bool:
	return Rect2(x, y, w, h).has_point(point)

func _handle_tap(p: Vector2) -> void:
	if overlay == "tutorial":
		if _hit(p, 57, 489, 366, 53): _start_tutorial()
		elif _hit(p, 57, 550, 366, 45): overlay = ""
		return
	if overlay == "milestone":
		for i in range(profile.reward_choices.size()):
			if _hit(p, 49, 303 + i * 94, 382, 80):
				if profile.claim_reward_choice(i): _save_profile(); overlay = "profile"
				return
		if _hit(p, 72, 589, 336, 36): overlay = "profile"
		return
	if overlay == "language_list":
		for i in range(Locale.LANGUAGES.size()):
			if _hit(p, 42 + (i % 2) * 202, 159 + (i / 2) * 58, 194, 51):
				language = str(Locale.LANGUAGES[i].code)
				overlay = "settings"
				_save_settings()
				return
		if _hit(p, 54, 678, 372, 54): overlay = "settings"
		return
	if overlay == "reset":
		if _hit(p, 55, 426, 370, 54):
			profile.reset()
			model.discovered.clear()
			player_records.clear()
			last_menu_location = 0
			pulse = 0.0
			_save_settings()
			_save_profile()
			DirAccess.remove_absolute(ProjectSettings.globalize_path("user://run.cfg"))
			overlay = "profile"
		elif _hit(p, 55, 495, 370, 54): overlay = "profile"
		return
	if overlay == "profile":
		if nickname_input.visible and not _hit(p, 46, 296, 378, 46):
			_nickname_committed(nickname_input.text)
		if _hit(p, 46, 296, 378, 46):
			nickname_input.visible = true
			nickname_input.text = profile.nickname
			nickname_input.grab_focus()
		elif _hit(p, 47, 395, 386, 134):
			var col := clampi(int((p.x - 47) / 77), 0, 4)
			var row := clampi(int((p.y - 395) / 73), 0, 1)
			profile.avatar_index = row * 5 + col
			_save_profile()
		elif _hit(p, 47, 658, 381, 34) and profile.has_milestone_reward():
			profile.open_reward_offer()
			_save_profile()
			overlay = "milestone"
		elif _hit(p, 47, 704, 178, 50): overlay = "reset"
		elif _hit(p, 241, 704, 187, 50): overlay = ""
		return
	if overlay == "shop":
		for i in range(4):
			if _hit(p, 43, 151 + i * 118, 394, 108):
				var item: Dictionary = Profile.ITEMS[shop_page * 4 + i]
				if not profile.owned.has(item.id):
					if not profile.buy(item.id): toast = t("not_enough_coins"); toast_time = 1.4
				elif p.x >= 324:
					if not profile.upgrade_item(item.id) and profile.item_level(item.id) < 5:
						toast = t("not_enough_coins"); toast_time = 1.4
				else: profile.equip(item.id)
				_save_profile()
				return
		if _hit(p, 43, 686, 112, 43): shop_page = maxi(0, shop_page - 1)
		elif _hit(p, 167, 686, 146, 43): overlay = ""
		elif _hit(p, 325, 686, 112, 43): shop_page = mini(4, shop_page + 1)
		return
	if overlay == "class":
		for i in range(5):
			if _hit(p, 43, 133 + i * 99, 394, 89): profile.class_id = i; _save_profile(); return
		if _hit(p, 43, 653, 394, 54): _start_run()
		elif _hit(p, 43, 717, 394, 48): overlay = ""
		return
	if overlay == "settings":
		if _hit(p, 52, 252, 376, 57):
			overlay = "language_list"
			toast_time = 0.0
		elif _hit(p, 52, 322, 376, 57): music_on = not music_on; _sync_music()
		elif _hit(p, 52, 392, 376, 57): sound_on = not sound_on
		elif _hit(p, 52, 462, 376, 57): vibration_on = not vibration_on
		elif _hit(p, 52, 577, 376, 59): overlay = "pause" if previous_phase == "combat" else ""
		_save_settings()
		return
	if overlay == "book":
		if _hit(p, 53, 655, 75, 57): book_page = maxi(0, book_page - 1)
		elif _hit(p, 143, 655, 194, 57): overlay = ""
		elif _hit(p, 352, 655, 75, 57): book_page = mini(maxi(0, ceili(model.discovered.size() / 14.0) - 1), book_page + 1)
		return
	if overlay == "pause":
		if _hit(p, 64, 363, 352, 55): overlay = ""; model.set_phase("combat")
		elif _hit(p, 64, 432, 352, 55): previous_phase = "combat"; overlay = "settings"
		elif _hit(p, 64, 501, 352, 55):
			if tutorial_stage >= 0: _finish_tutorial()
			else: _save_run(); model.set_phase("menu")
			overlay = ""
		return
	match model.phase:
		"menu":
			if _hit(p, 56, 357, 368, 62): _continue_run()
			elif _hit(p, 56, 431, 368, 62): overlay = "class"; toast_time = 0.0
			elif _hit(p, 56, 505, 178, 56): overlay = "profile"; toast_time = 0.0
			elif _hit(p, 246, 505, 178, 56): overlay = "shop"; toast_time = 0.0
			elif _hit(p, 56, 573, 368, 56): overlay = "book"; toast_time = 0.0
			elif _hit(p, 56, 641, 178, 56): overlay = "tutorial"; toast_time = 0.0
			elif _hit(p, 246, 641, 178, 56): previous_phase = "menu"; overlay = "settings"; toast_time = 0.0
		"combat":
			if _hit(p, 389, 25, 69, 55): overlay = "pause"; model.set_phase("paused")
			elif _hit(p, 32, 790, 416, 45): _cast()
			elif _hit(p, 31, 566, 203, 58): active_hand = 0
			elif _hit(p, 246, 566, 203, 58): active_hand = 1
			elif _hit(p, 32, 699, 415, 71):
				var col := clampi(int((p.x - 32) / 105), 0, 3)
				_choose(col)
			elif _hit(p, 112, 265, 258, 245): _cast()
		"reward":
			for i in range(3):
				if _hit(p, 50, 324 + i * 95, 380, 82): model.upgrade(i); break
		"dead", "won":
			if _hit(p, 64, 483, 352, 59): _start_run()
			elif _hit(p, 64, 552, 352, 50): model.set_phase("menu")

func _handle_key(key: int) -> void:
	if key == KEY_ESCAPE:
		if nickname_input != null and nickname_input.visible:
			_nickname_committed(nickname_input.text)
			return
		if overlay == "language_list": overlay = "settings"
		elif overlay == "milestone": overlay = "profile"
		elif overlay == "tutorial": overlay = ""
		elif overlay == "settings": overlay = "pause" if previous_phase == "combat" else ""
		elif overlay == "book" or overlay == "shop" or overlay == "class" or overlay == "profile": overlay = ""
		elif overlay == "reset": overlay = "profile"
		elif overlay == "pause": overlay = ""; model.set_phase("combat")
		elif model.phase == "combat": overlay = "pause"; model.set_phase("paused")
		return
	if model.phase != "combat" or overlay != "": return
	if key == KEY_LEFT and (tutorial_stage < 0 or tutorial_stage >= 3): model.dodge(-1)
	elif key == KEY_RIGHT and (tutorial_stage < 0 or tutorial_stage >= 3): model.dodge(1)
	elif key == KEY_TAB: active_hand = 1 - active_hand
	elif key == KEY_SPACE: _cast()
	elif key >= KEY_1 and key <= KEY_4: _choose(key - KEY_1)

func _choose(index: int) -> void:
	if index < 0 or index >= 4: return
	if tutorial_stage == 0 and (active_hand != 0 or index != 0): return
	if tutorial_stage == 1 and (active_hand != 1 or index != 1): return
	if tutorial_stage == 2 or tutorial_stage == 3: return
	var ingredient: int = Catalog.CLASS_LOADOUTS[model.class_id][index]
	if active_hand == 0: left_ingredient = ingredient
	else: right_ingredient = ingredient
	if tutorial_stage == 0 or tutorial_stage == 1: tutorial_stage += 1
	active_hand = 1 - active_hand
	toast = t("choose_right" if active_hand == 1 else "choose_left")
	toast_time = 1.2
	_play_effect("mix")

func _start_run() -> void:
	last_boss_intro_round = -1
	last_rendered_enemy = -1
	left_ingredient = Catalog.CLASS_LOADOUTS[profile.class_id][0]
	right_ingredient = Catalog.CLASS_LOADOUTS[profile.class_id][1]
	active_hand = 0
	tutorial_shown = false
	tutorial_stage = -1
	overlay = ""
	model.start({"class_id":profile.class_id, "level":profile.level(), "bonuses":profile.bonuses(), "completed_runs":profile.completed_runs})
	_save_run()

func _start_tutorial() -> void:
	overlay = ""
	tutorial_stage = 0
	tutorial_shown = true
	active_hand = 0
	left_ingredient = 6
	right_ingredient = 6
	model.start({"class_id":0, "level":1, "seed":101})
	model.encounter_order[0] = 2
	model._spawn()
	model.enemy_hp = 125.0
	model.enemy_max = 125.0
	model.attack_time = 10.0

func _continue_run() -> void:
	var config := ConfigFile.new()
	if config.load("user://run.cfg") != OK: return
	tutorial_stage = -1
	if model.restore(config.get_value("run", "state", {})):
		left_ingredient = clampi(int(config.get_value("run", "left", 0)), 0, Catalog.INGREDIENTS.size() - 1)
		right_ingredient = clampi(int(config.get_value("run", "right", 1)), 0, Catalog.INGREDIENTS.size() - 1)
		active_hand = int(config.get_value("run", "hand", 0))
		overlay = ""
		last_menu_location = clampi(model.location_index, 0, BACKGROUNDS.size() - 1)
		last_rendered_enemy = model.enemy_type
		last_boss_intro_round = model.kills if model.is_boss_type(model.enemy_type) else -1
		_sync_music()
	else:
		DirAccess.remove_absolute(ProjectSettings.globalize_path("user://run.cfg"))
		toast = t("save_invalid")
		toast_time = 2.0

func _cast() -> void:
	if tutorial_stage >= 0 and tutorial_stage != 2 and tutorial_stage != 4: return
	if tutorial_stage == 2 and (left_ingredient != 0 or right_ingredient != 2): return
	if tutorial_stage == 2:
		tutorial_stage = 3
		model.attack_time = 1.4
	if model.cast(left_ingredient, right_ingredient): _save_run()

func _on_game_event(kind: String, amount: float) -> void:
	match kind:
		"cast":
			cast_anim_time = 0.32
			recoil_time = 0.24
			shake_time = 0.13
			last_recipe = Catalog.recipe(left_ingredient, right_ingredient).id
			effect_time = 0.7
			flash_time = 0.13
			float_time = 0.9
			float_number = "−%d" % int(amount)
			_play_effect("cast")
		"warning":
			toast = t("dodge"); toast_time = 1.2
			if model.is_boss_type(model.enemy_type): _play_effect("boss_%d_attack" % model.enemy_type)
		"hurt":
			shake_time = 0.28
			_save_run()
			impact_time = 0.38
			toast = t("hit_msg") + " −%d" % int(amount); toast_time = 1.1
			_vibrate()
			_play_effect("hurt")
		"dodge":
			_save_run()
			toast = t("dodge_msg"); toast_time = 1.0
			_play_effect("dodge")
		"dodge_move":
			_save_run()
			_play_effect("dodge")
			if tutorial_stage == 3 and model.locked: tutorial_stage = 4
		"perfect_dodge":
			_save_run()
			toast = t("perfect_dodge"); toast_time = 1.4
			_play_effect("reward")
		"kill":
			if tutorial_stage >= 0:
				call_deferred("_finish_tutorial")
				return
			shake_time = 0.26 if model.is_boss_type(model.enemy_type) else 0.12
			var gain: Dictionary = profile.reward(model.enemy_type, model.run_goal / 10 - 1, model.class_id)
			var leveled_up := model.apply_level(profile.level())
			toast = (t("level_up") + " %d  •  " % profile.level() + t("level_bonus")) if leveled_up else (t("kill_msg") + "  ◈%d  XP+%d" % [gain.coins, gain.xp])
			toast_time = 2.1 if leveled_up else 1.8
			_save_profile()
			_save_run()
			_play_effect("boss_%d_death" % model.enemy_type if model.is_boss_type(model.enemy_type) else "reward")
		"empty":
			toast = t("empty"); toast_time = 1.4
		"discovery":
			toast = t("discovery"); toast_time = 1.4
			_save_settings()
		"location":
			last_menu_location = clampi(model.location_index, 0, BACKGROUNDS.size() - 1)
			_save_settings()
			_play_effect("reward")
			_sync_music()

func _on_phase_changed() -> void:
	if tutorial_stage >= 0 and model.phase in ["dead", "won"]:
		call_deferred("_finish_tutorial")
		return
	if model.phase == "combat" and model.enemy_type != last_rendered_enemy:
		spawn_visual_time = 0.45
		last_rendered_enemy = model.enemy_type
	if model.phase == "combat" and model.is_boss_type(model.enemy_type) and model.kills != last_boss_intro_round:
		last_boss_intro_round = model.kills
		_play_effect("boss_%d_intro" % model.enemy_type)
	if model.phase == "combat" and model.kills == 0 and not tutorial_shown:
		tutorial_shown = true
		toast = t("choose_left")
		toast_time = 3.0
	if model.phase == "dead" or model.phase == "won":
		if model.phase == "won":
			profile.completed_runs += 1
			_save_profile()
		player_records.append({"kills":model.kills, "time":model.elapsed, "won":model.phase == "won"})
		_save_settings()
		DirAccess.remove_absolute(ProjectSettings.globalize_path("user://run.cfg"))
	elif model.phase in ["intro", "combat", "paused", "reward", "boss_victory", "round_clear"]:
		_save_run()
	_sync_music()
	queue_redraw()

func _finish_tutorial() -> void:
	tutorial_stage = -1
	model.set_phase("menu")
	toast = t("tutorial_done")
	toast_time = 2.2

func _build_audio() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.volume_db = -13.0
	add_child(music_player)
	music_next_player = AudioStreamPlayer.new()
	music_next_player.volume_db = -60.0
	add_child(music_next_player)
	for i in 4:
		var player := AudioStreamPlayer.new()
		player.volume_db = -7.0
		add_child(player)
		effect_players.append(player)
	_sync_music()

func _sync_music() -> void:
	if music_player == null: return
	if not music_on or model.phase == "paused":
		music_player.stop()
		music_next_player.stop()
		music_track = ""
		return
	var desired := "menu" if model.phase in ["menu", "dead", "won"] else "location_%d" % model.location_index
	if desired == music_track: return
	var stream := load("res://assets/audio/%s.wav" % desired) as AudioStreamWAV
	if stream == null: return
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	if music_track == "":
		music_player.stream = stream
		music_player.volume_db = -13.0
		music_player.play()
		music_fade = 1.0
	else:
		music_next_player.stream = stream
		music_next_player.volume_db = -60.0
		music_next_player.play()
		music_fade = 0.0
	music_track = desired

func _update_music(delta: float) -> void:
	if music_next_player == null or not music_next_player.playing: return
	music_fade = minf(1.0, music_fade + delta / 1.0)
	music_player.volume_db = lerpf(-13.0, -60.0, music_fade)
	music_next_player.volume_db = lerpf(-60.0, -13.0, music_fade)
	if music_fade >= 1.0:
		music_player.stop()
		var previous := music_player
		music_player = music_next_player
		music_next_player = previous

func _play_effect(name: String) -> void:
	if not sound_on or effect_players.is_empty(): return
	var stream := load("res://assets/audio/%s.wav" % name) as AudioStreamWAV
	if stream == null: return
	for player in effect_players:
		if not player.playing:
			player.stream = stream
			player.play()
			return
	effect_players[0].stream = stream
	effect_players[0].play()

func _vibrate() -> void:
	if vibration_on and OS.has_feature("mobile"):
		Input.vibrate_handheld(80)

func _save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("options", "language", language)
	config.set_value("options", "sound", sound_on)
	config.set_value("options", "music", music_on)
	config.set_value("options", "vibration", vibration_on)
	config.set_value("progress", "recipes", model.discovered)
	config.set_value("progress", "runs", player_records.slice(-20))
	config.set_value("progress", "last_location", last_menu_location)
	config.save("user://alchemist.cfg")

func _load_settings() -> void:
	var config := ConfigFile.new()
	if config.load("user://alchemist.cfg") != OK: return
	language = str(config.get_value("options", "language", "ru"))
	sound_on = bool(config.get_value("options", "sound", true))
	music_on = bool(config.get_value("options", "music", true))
	vibration_on = bool(config.get_value("options", "vibration", true))
	model.discovered = config.get_value("progress", "recipes", [])
	player_records = config.get_value("progress", "runs", [])
	last_menu_location = clampi(int(config.get_value("progress", "last_location", 0)), 0, BACKGROUNDS.size() - 1)

func _save_profile() -> void:
	var config := ConfigFile.new()
	config.set_value("profile", "data", profile.to_dict())
	config.save("user://profile.cfg")

func _load_profile() -> void:
	var config := ConfigFile.new()
	if config.load("user://profile.cfg") == OK:
		profile.from_dict(config.get_value("profile", "data", {}))

func _save_run() -> void:
	if tutorial_stage >= 0 or model.phase in ["menu", "dead", "won"]: return
	var config := ConfigFile.new()
	config.set_value("run", "state", model.snapshot())
	config.set_value("run", "left", left_ingredient)
	config.set_value("run", "right", right_ingredient)
	config.set_value("run", "hand", active_hand)
	config.save("user://run.cfg")

func _nickname_committed(value: String) -> void:
	profile.nickname = value.strip_edges().substr(0, 20)
	if profile.nickname == "": profile.nickname = "Алхимик"
	nickname_input.visible = false
	nickname_input.release_focus()
	if OS.has_feature("mobile"): DisplayServer.virtual_keyboard_hide()
	_save_profile()

func _nickname_focus_lost() -> void:
	if nickname_input.visible: _nickname_committed(nickname_input.text)

func _notification(what: int) -> void:
	if what in [NOTIFICATION_WM_CLOSE_REQUEST, NOTIFICATION_APPLICATION_PAUSED] and model != null:
		_save_run()
		_save_profile()
