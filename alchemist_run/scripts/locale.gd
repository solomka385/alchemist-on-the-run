extends RefCounted

const Extra = preload("res://scripts/locale_extra.gd")
const LANGUAGES = [
	{"code":"ru", "name":"Русский"}, {"code":"en", "name":"English"}, {"code":"zh", "name":"简体中文"},
	{"code":"hi", "name":"हिन्दी"}, {"code":"es", "name":"Español"},
	{"code":"ar", "name":"العربية"}, {"code":"fr", "name":"Français"},
	{"code":"bn", "name":"বাংলা"}, {"code":"pt", "name":"Português"},
	{"code":"ur", "name":"اردو"},
	{"code":"id", "name":"Indonesia"}, {"code":"de", "name":"Deutsch"},
	{"code":"ja", "name":"日本語"}, {"code":"pcm", "name":"Naija Pidgin"},
	{"code":"arz", "name":"مصري"}
]

const TEXT = {
	"ru": {
		"title":"АЛХИМИК НА БЕГУ", "subtitle":"ПОСЛЕДНИЙ ЗАБЕГ ЧЕРЕЗ ЧУМНОЙ ГОРОД",
		"start":"НАЧАТЬ ЗАБЕГ", "book":"КНИГА РЕЦЕПТОВ", "settings":"НАСТРОЙКИ",
		"back":"НАЗАД", "resume":"ПРОДОЛЖИТЬ", "menu":"В ГЛАВНОЕ МЕНЮ",
		"dead":"АЛХИМИК ПАЛ", "won":"ГОРОД ПОЗАДИ", "again":"НОВЫЙ ЗАБЕГ",
		"health":"ЗДОРОВЬЕ", "mana":"МАНА", "wave":"ВРАГ", "boss":"БОСС",
		"moss_short":"МОХ", "dew_short":"РОСА", "pollen_short":"ПЫЛЬЦА", "bile_short":"ЖЕЛЧЬ", "thorn_short":"ТЕРН", "echo_short":"КОРЕНЬ", "ash_short":"ПЕПЕЛ", "mercury_short":"РТУТЬ",
		"damage":"УРОН", "burn":"ОГОНЬ", "slow":"ХОЛОД", "pierce":"БРОНЯ", "heal_effect":"ЛЕЧЕНИЕ", "stagger":"СБОЙ", "corrode":"КОРРОЗИЯ", "mana_return":"МАНА",
		"choose_left":"ВЫБЕРИТЕ ЛЕВУЮ КОЛБУ", "choose_right":"ВЫБЕРИТЕ ПРАВУЮ КОЛБУ", "preview":"РЕЗУЛЬТАТ СМЕСИ",
		"cast":"СМЕШАТЬ / БРОСИТЬ", "basic":"ОСКОЛОК", "left":"ЛЕВАЯ", "right":"ПРАВАЯ",
		"tap":"Нажмите ингредиент для выбранной руки", "dodge":"Свайп вбок — уклонение", 
		"reward":"ПРИВАЛ У ПЕЧИ", "reward_sub":"Выберите одно улучшение", 
		"heal":"ЛЕЧЕБНЫЙ ОТВАР", "heal_desc":"+35 здоровья",
		"power":"ОСТРАЯ РЕАКЦИЯ", "power_desc":"+20% урона зельями",
		"focus":"ВТОРОЕ ДЫХАНИЕ", "focus_desc":"+30 маны и быстрое восстановление",
		"language":"ЯЗЫК", "audio":"ЗВУКИ", "music":"МУЗЫКА", "vibration":"ВИБРАЦИЯ", "on":"ВКЛ", "off":"ВЫКЛ",
		"empty":"НЕДОСТАТОЧНО МАНЫ — ПОДОЖДИТЕ ИЛИ УКЛОНИТЕСЬ", "dodge_msg":"УКЛОНЕНИЕ +8 МАНЫ",
		"hit_msg":"ПОЛУЧЕН УРОН", "kill_msg":"ВРАГ ПОВЕРЖЕН +14 МАНЫ",
		"discovery":"НОВЫЙ РЕЦЕПТ", "book_empty":"Рецепты открываются при первом броске.",
		"control":"Клавиши: 1–8 ингредиенты · Tab смена руки · ←/→ уклонение · Пробел бросок",
		"time":"ВРЕМЯ", "score":"ПОБЕЖДЕНО", "paused":"ПАУЗА",
		"enemy0":"ПЕЧНОЙ СТРАЖ", "enemy1":"ПЕПЕЛЬНЫЙ ГОНЕЦ", "enemy2":"ХОЗЯЙКА ТЕПЛИЦЫ", "enemy3":"ЗЕРКАЛЬНЫЙ ПЁС", "enemy4":"ЧУМНОЙ ПИСАРЬ", "enemy5":"СТЕКОЛЬЩИК", "enemy6":"РЖАВЫЙ ХОР", "enemy7":"ЧАСОВАЯ ИСКРА", "enemy8":"СБОРЩИК ОСКОЛКОВ", "enemy9":"БЕЗЛИКИЙ АЛХИМИК",
		"trait_armor":"БРОНЯ", "trait_fast":"БЫСТРЫЙ УДАР", "trait_heal":"ЛЕЧИТСЯ ПРИ УДАРЕ", "trait_reflect":"ОТРАЖАЕТ УРОН", "trait_poison":"ОТРАВЛЯЕТ", "trait_glass":"ЗЕРКАЛЬНАЯ БРОНЯ", "trait_drain":"ПОГЛОЩАЕТ МАНУ", "trait_flash":"МОЛНИЕНОСНЫЙ", "trait_heavy":"ТЯЖЁЛЫЙ УДАР", "trait_final":"СИЛЬНЫЙ УДАР",
		"place0":"МЕДНЫЙ ПРОХОД", "place1":"ЧУМНАЯ ТЕПЛИЦА", "place2":"СТЕКЛЯННЫЙ ЦЕХ", "place3":"АРХИВ ЗАБЫТЫХ", "place4":"ПОСЛЕДНЯЯ ЦИТАДЕЛЬ", "place_sub":"НОВАЯ ЛОКАЦИЯ", "continue":"НАЧАТЬ БОЙ",
		"moss":"УГОЛЬНЫЙ МОХ", "dew":"ЛУННАЯ РОСА", "pollen":"ГРОМОВАЯ ПЫЛЬЦА",
		"bile":"СТЕКЛЯННАЯ ЖЕЛЧЬ", "thorn":"КРОВЯНОЙ ТЕРН", "echo":"ЭХО-КОРЕНЬ", "ash":"СОННЫЙ ПЕПЕЛ", "mercury":"ЖИВАЯ РТУТЬ",
		"wildfire":"ДИКОЕ ПЛАМЯ", "black_ice":"ЧЁРНЫЙ ИНЕЙ", "stormfire":"ГРОЗОВОЕ ПЛАМЯ",
		"caustic_fire":"ЕДКОЕ ПЛАМЯ", "blood_ember":"КРОВАВЫЙ УГОЛЬ", "ember_echo":"ОТЗВУК ЖАРА",
		"deep_frost":"ГЛУБОКИЙ ХОЛОД", "static_frost":"СТАТИЧЕСКИЙ ИНЕЙ", "glass_winter":"СТЕКЛЯННАЯ ЗИМА",
		"red_dew":"КРАСНАЯ РОСА", "winter_echo":"ЗИМНЕЕ ЭХО", "thunder":"ГРОМОВОЙ УДАР",
		"lightning_glass":"МОЛНИЯ В СТЕКЛЕ", "living_spark":"ЖИВАЯ ИСКРА", "storm_echo":"ОТЗВУК ГРОЗЫ",
		"solvent":"РАСТВОРИТЕЛЬ", "venom_bloom":"ЯДОВИТЫЙ ЦВЕТ", "glass_echo":"ЗВОНКОЕ ЭХО",
		"heartroot":"СЕРДЦЕВИНА", "living_echo":"ЖИВОЕ ЭХО", "afterimage":"ПОСЛЕСВЕЧЕНИЕ",
		"cinder_sleep":"СОННЫЙ УГОЛЬ", "quicksilver_flame":"РТУТНОЕ ПЛАМЯ", "sleeping_snow":"СОННЫЙ СНЕГ", "silver_frost":"СЕРЕБРЯНЫЙ ИНЕЙ", "silent_storm":"ТИХАЯ ГРОЗА", "chain_lightning":"ЦЕПНАЯ МОЛНИЯ", "sleeping_acid":"СОННАЯ КИСЛОТА", "silver_solvent":"РТУТНЫЙ РАСТВОР", "dreamroot":"КОРЕНЬ СНОВ", "silver_blood":"СЕРЕБРЯНАЯ КРОВЬ", "dream_echo":"ЭХО СНА", "silver_echo":"СЕРЕБРЯНОЕ ЭХО", "deep_sleep":"ГЛУБОКИЙ СОН", "mercury_dream":"РТУТНЫЙ СОН", "mercury_wave":"РТУТНАЯ ВОЛНА",
		"continue_run":"ПРОДОЛЖИТЬ ЗАБЕГ", "new_run":"НОВЫЙ ЗАБЕГ", "profile":"ПРОФИЛЬ", "shop":"ЛАВКА АЛХИМИКА", "level":"УРОВЕНЬ", "level_up":"НОВЫЙ УРОВЕНЬ", "level_bonus":"СИЛА И ЗДОРОВЬЕ ВЫРОСЛИ", "level_effect":"БОНУС УРОВНЯ", "nickname":"ИМЯ АЛХИМИКА", "choose_avatar":"ВЫБЕРИТЕ АВАТАР", "choose_class":"ВЫБЕРИТЕ ШКОЛУ АЛХИМИИ", "class":"ШКОЛА", "reset_profile":"СБРОСИТЬ ПРОФИЛЬ", "reset_confirm":"Удалить уровень, монеты, покупки и текущий забег?", "not_enough_coins":"НЕДОСТАТОЧНО МОНЕТ", "equip":"НАДЕТЬ", "equipped":"НАДЕТО", "boss_down":"БОСС ПОВЕРЖЕН", "boss_reward":"Впереди привал и выбор улучшения", "slot_head":"ГОЛОВА", "slot_hands":"РУКИ", "slot_charm":"ТАЛИСМАН",
		"class_ember":"ПИРОАЛХИМИК", "class_ember_desc":"Урон +10%, горение +80%", "class_frost":"КРИОАЛХИМИК", "class_frost_desc":"Заморозка действует на 80% дольше", "class_storm":"ГРОЗОВИК", "class_storm_desc":"Мана +3/с, уклонение даёт ещё +5", "class_vital":"ВИТАЛИСТ", "class_vital_desc":"Здоровье +35, лечение +50%, регенерация",
		"item_hood":"МЕДНЫЙ КАПЮШОН", "item_hood_desc":"Здоровье +12", "item_crown":"ЛУННЫЙ ВЕНЕЦ", "item_crown_desc":"Мана +18", "item_gloves":"ПЕЧНЫЕ ПЕРЧАТКИ", "item_gloves_desc":"Урон зелий +8%", "item_gauntlets":"РУНЫ В ПЕРЧАТКАХ", "item_gauntlets_desc":"Урон зелий +16%", "item_vial":"КОЛБА ПАМЯТИ", "item_vial_desc":"Мана +12, восстановление +0,6/с", "item_heart":"ЖИВОЕ СЕРДЦЕ", "item_heart_desc":"Здоровье +25, восстановление +0,3/с",
		"item_ash_boots":"ПЕПЕЛЬНЫЕ САПОГИ", "item_ash_boots_desc":"Восстановление маны +0,4/с", "item_frost_boots":"ЛЕДЯНЫЕ САПОГИ", "item_frost_boots_desc":"Здоровье +8, холод +10%", "item_ember_ring":"УГОЛЬНОЕ КОЛЬЦО", "item_ember_ring_desc":"Горение +12%", "item_mercury_ring":"РТУТНОЕ КОЛЬЦО", "item_mercury_ring_desc":"Мана +20, восстановление +0,2/с", "item_plague_mask":"ЧУМНАЯ МАСКА", "item_plague_mask_desc":"Здоровье +16", "item_raven_mask":"ВОРОНЬЯ МАСКА", "item_raven_mask_desc":"Урон зелий +12%", "item_copper_belt":"МЕДНЫЙ ПОЯС", "item_copper_belt_desc":"Здоровье +15, мана +5", "item_storm_belt":"ГРОЗОВОЙ ПОЯС", "item_storm_belt_desc":"Восстановление маны +1/с", "item_glass_amulet":"СТЕКЛЯННЫЙ АМУЛЕТ", "item_glass_amulet_desc":"Урон +13%, холод +10%", "item_eclipse_amulet":"АМУЛЕТ ЗАТМЕНИЯ", "item_eclipse_amulet_desc":"Урон +18%, горение +15%",
		"slot_feet":"НОГИ", "slot_ring":"КОЛЬЦО", "slot_face":"ЛИЦО", "slot_belt":"ПОЯС",
		"enemy10":"КОРОЛЬ КОЛОКОЛОВ", "enemy11":"ГРИБНАЯ КОРОЛЕВА", "enemy12":"ЧАСОВОЙ РЫЦАРЬ", "enemy13":"ПЕПЕЛЬНЫЙ ОРАКУЛ",
		"trait_bell":"ПОГЛОЩАЕТ МАНУ", "trait_spores":"ЯДОВИТЫЕ СПОРЫ", "trait_clock":"УСКОРЯЕТ АТАКУ", "trait_oracle":"ПРОКЛЯТЫЙ УДАР",
		"place5":"МЕДНЫЙ АКВЕДУК", "place6":"КОСТЯНАЯ ОБСЕРВАТОРИЯ", "place7":"СОЛЯНОЙ СОБОР", "place8":"ЧАСОВАЯ БАШНЯ",
		"enemy_down":"ВРАГ ПОВЕРЖЕН", "next_foe":"СЛЕДУЮЩИЙ ПРОТИВНИК ПРИБЛИЖАЕТСЯ", "shop_hint":"Предмет — надеть; стрелка — улучшить (+25% за уровень)", "max_level":"МАКС",
		"enemy14":"СОЛЯНОЙ ВЕЛИКАН", "enemy15":"ЗМЕЙ АКВЕДУКА", "enemy16":"ЗВЁЗДНЫЙ ПРИЗРАК", "enemy17":"КУЗНЕЧНАЯ ВДОВА",
		"trait_salt":"РАЗБИВАЕТ ЩИТ", "trait_serpent":"ДОЛГИЙ ЯД", "trait_star":"КРАДЁТ МАНУ", "trait_widow":"УСКОРЯЕТСЯ",
		"place9":"КУЗНЕЧНЫЙ МОСТ", "place10":"АЛХИМИЧЕСКИЙ ЛАЗАРЕТ", "place11":"ВОРОНИЙ МОНАСТЫРЬ", "place12":"ПРИЗМЕННОЕ ХРАНИЛИЩЕ",
		"item_ward_lantern":"СТОРОЖЕВОЙ ФОНАРЬ", "item_ward_lantern_desc":"Здоровье +18, мана +10", "item_transfusion":"КОЛБА ПЕРЕЛИВАНИЯ", "item_transfusion_desc":"Здоровье +22, восстановление +0,5/с", "item_dodge_boots":"САПОГИ ТЕНИ", "item_dodge_boots_desc":"Мана +15, восстановление +0,8/с", "item_royal_crown":"КОРОЛЕВСКИЙ ВЕНЕЦ", "item_royal_crown_desc":"Здоровье +30, урон +10%",
		"class_shadow":"ТЕНЕВОЙ АЛХИМИК", "class_shadow_desc":"Яд и щиты сильнее, урон +15%", "night_salt":"СУМРАЧНАЯ СОЛЬ", "night_salt_short":"СОЛЬ", "star_resin":"ЗВЁЗДНАЯ СМОЛА", "star_resin_short":"СМОЛА", "mirror_sap":"ЗЕРКАЛЬНЫЙ СОК", "mirror_sap_short":"СОК", "void_thorn":"ШИП ПУСТОТЫ", "void_thorn_short":"ШИП", "poison":"ЯД", "shield":"ЩИТ",
		"perfect_dodge":"ИДЕАЛЬНОЕ УКЛОНЕНИЕ · +МАНА И УРОН", "save_invalid":"СОХРАНЕНИЕ ПОВРЕЖДЕНО", "tutorial":"ОБУЧЕНИЕ", "milestone_reward":"ЗАБРАТЬ НАГРАДУ", "reward_item":"НОВЫЙ ПРЕДМЕТ", "reward_upgrade":"УЛУЧШЕНИЕ", "crown":"МАСТЕР АЛХИМИИ", "poison_effect":"ЯД", "shield_effect":"ЩИТ", "new_mix":"НОВАЯ СМЕСЬ", "tutorial_intro":"СОБЕРИ ЗЕЛЬЕ, БРОСЬ ЕГО В БОССА И УКЛОНИСЬ ОТ АТАКИ.", "tutorial_step_0":"ЛЕВАЯ РУКА: ВЫБЕРИ ПЕРВЫЙ ИНГРЕДИЕНТ", "tutorial_step_1":"ПРАВАЯ РУКА: ВЫБЕРИ ВТОРОЙ ИНГРЕДИЕНТ", "tutorial_step_2":"НАЖМИ «БРОСИТЬ», ЧТОБЫ УДАРИТЬ БОССА", "tutorial_step_3":"ДОЖДИСЬ МЕТКИ АТАКИ И СДЕЛАЙ СВАЙП В СТОРОНУ", "tutorial_step_4":"ТЕПЕРЬ ДОБЕЙ БОССА. УКЛОНЕНИЕ УСИЛИЛО ЗЕЛЬЕ", "tutorial_done":"ОБУЧЕНИЕ ПРОЙДЕНО"
	},
	"en": {
		"title":"ALCHEMIST ON THE RUN", "subtitle":"ONE LAST RUN THROUGH THE PLAGUE CITY",
		"start":"START RUN", "book":"RECIPE BOOK", "settings":"SETTINGS",
		"back":"BACK", "resume":"RESUME", "menu":"MAIN MENU",
		"dead":"ALCHEMIST FALLEN", "won":"CITY BEHIND YOU", "again":"NEW RUN",
		"health":"HEALTH", "mana":"MANA", "wave":"FOE", "boss":"BOSS",
		"moss_short":"MOSS", "dew_short":"DEW", "pollen_short":"POLLEN", "bile_short":"BILE", "thorn_short":"THORN", "echo_short":"ROOT", "ash_short":"ASH", "mercury_short":"MERCURY",
		"damage":"DMG", "burn":"BURN", "slow":"SLOW", "pierce":"ARMOR", "heal_effect":"HEAL", "stagger":"STAGGER", "corrode":"CORRODE", "mana_return":"MANA",
		"choose_left":"CHOOSE LEFT FLASK", "choose_right":"CHOOSE RIGHT FLASK", "preview":"MIX RESULT",
		"cast":"MIX / THROW", "basic":"SHARD", "left":"LEFT", "right":"RIGHT",
		"tap":"Tap an ingredient for the selected hand", "dodge":"Swipe sideways to dodge",
		"reward":"FURNACE REST", "reward_sub":"Choose one upgrade",
		"heal":"HEALING DRAUGHT", "heal_desc":"Restore 35 health",
		"power":"SHARP REACTION", "power_desc":"+20% potion damage",
		"focus":"SECOND WIND", "focus_desc":"+30 mana and faster recovery",
		"language":"LANGUAGE", "audio":"SOUND FX", "music":"MUSIC", "vibration":"VIBRATION", "on":"ON", "off":"OFF",
		"empty":"NOT ENOUGH MANA — WAIT OR DODGE", "dodge_msg":"DODGED +8 MANA",
		"hit_msg":"DAMAGE TAKEN", "kill_msg":"FOE DEFEATED +14 MANA",
		"discovery":"NEW RECIPE", "book_empty":"Recipes unlock on their first throw.",
		"control":"Keys: 1–8 ingredients · Tab swap hand · ←/→ dodge · Space cast",
		"time":"TIME", "score":"DEFEATED", "paused":"PAUSED",
		"enemy0":"FURNACE WARDEN", "enemy1":"ASH COURIER", "enemy2":"GREENHOUSE MATRIARCH", "enemy3":"MIRROR HOUND", "enemy4":"PLAGUE SCRIBE", "enemy5":"GLASSMAKER", "enemy6":"RUST CHOIR", "enemy7":"CLOCKWORK WISP", "enemy8":"SHARD COLLECTOR", "enemy9":"FACELESS ALCHEMIST",
		"trait_armor":"ARMORED", "trait_fast":"FAST ATTACK", "trait_heal":"HEALS ON HIT", "trait_reflect":"REFLECTS DAMAGE", "trait_poison":"POISON ATTACK", "trait_glass":"MIRROR ARMOR", "trait_drain":"DRAINS MANA", "trait_flash":"LIGHTNING FAST", "trait_heavy":"HEAVY ATTACK", "trait_final":"POWERFUL ATTACK",
		"place0":"COPPER PASSAGE", "place1":"PLAGUE GREENHOUSE", "place2":"GLASSWORKS", "place3":"FORGOTTEN ARCHIVES", "place4":"LAST CITADEL", "place_sub":"NEW LOCATION", "continue":"BEGIN FIGHT",
		"moss":"COAL MOSS", "dew":"MOON DEW", "pollen":"THUNDER POLLEN",
		"bile":"GLASS BILE", "thorn":"BLOODTHORN", "echo":"ECHO ROOT", "ash":"SLEEP ASH", "mercury":"LIVING MERCURY",
		"wildfire":"WILDFIRE", "black_ice":"BLACK ICE", "stormfire":"STORMFIRE",
		"caustic_fire":"CAUSTIC FIRE", "blood_ember":"BLOOD EMBER", "ember_echo":"EMBER ECHO",
		"deep_frost":"DEEP FROST", "static_frost":"STATIC FROST", "glass_winter":"GLASS WINTER",
		"red_dew":"RED DEW", "winter_echo":"WINTER ECHO", "thunder":"THUNDER",
		"lightning_glass":"LIGHTNING GLASS", "living_spark":"LIVING SPARK", "storm_echo":"STORM ECHO",
		"solvent":"SOLVENT", "venom_bloom":"VENOM BLOOM", "glass_echo":"GLASS ECHO",
		"heartroot":"HEARTROOT", "living_echo":"LIVING ECHO", "afterimage":"AFTERIMAGE",
		"cinder_sleep":"CINDER SLEEP", "quicksilver_flame":"QUICKSILVER FLAME", "sleeping_snow":"SLEEPING SNOW", "silver_frost":"SILVER FROST", "silent_storm":"SILENT STORM", "chain_lightning":"CHAIN LIGHTNING", "sleeping_acid":"SLEEPING ACID", "silver_solvent":"SILVER SOLVENT", "dreamroot":"DREAMROOT", "silver_blood":"SILVER BLOOD", "dream_echo":"DREAM ECHO", "silver_echo":"SILVER ECHO", "deep_sleep":"DEEP SLEEP", "mercury_dream":"MERCURY DREAM", "mercury_wave":"MERCURY WAVE",
		"continue_run":"CONTINUE RUN", "new_run":"NEW RUN", "profile":"PROFILE", "shop":"ALCHEMIST SHOP", "level":"LEVEL", "level_up":"LEVEL UP", "level_bonus":"POWER AND HEALTH INCREASED", "level_effect":"LEVEL BONUS", "nickname":"ALCHEMIST NAME", "choose_avatar":"CHOOSE AVATAR", "choose_class":"CHOOSE ALCHEMY SCHOOL", "class":"SCHOOL", "reset_profile":"RESET PROFILE", "reset_confirm":"Delete level, coins, purchases and current run?", "not_enough_coins":"NOT ENOUGH COINS", "equip":"EQUIP", "equipped":"EQUIPPED", "boss_down":"BOSS DEFEATED", "boss_reward":"Rest and an upgrade await", "slot_head":"HEAD", "slot_hands":"HANDS", "slot_charm":"CHARM",
		"class_ember":"PYRO ALCHEMIST", "class_ember_desc":"Damage +10%, burn +80%", "class_frost":"CRYO ALCHEMIST", "class_frost_desc":"Freeze lasts 80% longer", "class_storm":"STORM ALCHEMIST", "class_storm_desc":"Mana +3/s, dodge grants +5 more", "class_vital":"VITALIST", "class_vital_desc":"Health +35, healing +50%, regeneration",
		"item_hood":"COPPER HOOD", "item_hood_desc":"Health +12", "item_crown":"MOON CROWN", "item_crown_desc":"Mana +18", "item_gloves":"FURNACE GLOVES", "item_gloves_desc":"Potion damage +8%", "item_gauntlets":"RUNIC GAUNTLETS", "item_gauntlets_desc":"Potion damage +16%", "item_vial":"MEMORY VIAL", "item_vial_desc":"Mana +12, recovery +0.6/sec", "item_heart":"LIVING HEART", "item_heart_desc":"Health +25, recovery +0.3/sec",
		"item_ash_boots":"ASH BOOTS", "item_ash_boots_desc":"Mana recovery +0.4/sec", "item_frost_boots":"FROST BOOTS", "item_frost_boots_desc":"Health +8, frost +10%", "item_ember_ring":"EMBER RING", "item_ember_ring_desc":"Burn +12%", "item_mercury_ring":"MERCURY RING", "item_mercury_ring_desc":"Mana +20, recovery +0.2/sec", "item_plague_mask":"PLAGUE MASK", "item_plague_mask_desc":"Health +16", "item_raven_mask":"RAVEN MASK", "item_raven_mask_desc":"Potion damage +12%", "item_copper_belt":"COPPER BELT", "item_copper_belt_desc":"Health +15, mana +5", "item_storm_belt":"STORM BELT", "item_storm_belt_desc":"Mana recovery +1/sec", "item_glass_amulet":"GLASS AMULET", "item_glass_amulet_desc":"Damage +13%, frost +10%", "item_eclipse_amulet":"ECLIPSE AMULET", "item_eclipse_amulet_desc":"Damage +18%, burn +15%",
		"slot_feet":"FEET", "slot_ring":"RING", "slot_face":"FACE", "slot_belt":"BELT",
		"enemy10":"BELL KING", "enemy11":"FUNGAL QUEEN", "enemy12":"CLOCK KNIGHT", "enemy13":"ASH ORACLE",
		"trait_bell":"DRAINS MANA", "trait_spores":"POISON SPORES", "trait_clock":"SPEEDS ATTACK", "trait_oracle":"CURSED STRIKE",
		"place5":"COPPER AQUEDUCT", "place6":"BONE OBSERVATORY", "place7":"SALT CATHEDRAL", "place8":"CLOCK TOWER",
		"enemy_down":"FOE DEFEATED", "next_foe":"NEXT FOE APPROACHING", "shop_hint":"Tap item to equip; arrow to upgrade (+25% per level)", "max_level":"MAX",
		"enemy14":"SALT GIANT", "enemy15":"AQUEDUCT SERPENT", "enemy16":"STAR REVENANT", "enemy17":"FORGE WIDOW",
		"trait_salt":"SHATTERS SHIELD", "trait_serpent":"LONG POISON", "trait_star":"STEALS MANA", "trait_widow":"ACCELERATES",
		"place9":"FORGE BRIDGE", "place10":"ALCHEMICAL INFIRMARY", "place11":"RAVEN CLOISTER", "place12":"PRISM VAULT",
		"item_ward_lantern":"WARD LANTERN", "item_ward_lantern_desc":"Health +18, mana +10", "item_transfusion":"TRANSFUSION VIAL", "item_transfusion_desc":"Health +22, recovery +0.5/s", "item_dodge_boots":"SHADOW BOOTS", "item_dodge_boots_desc":"Mana +15, recovery +0.8/s", "item_royal_crown":"ROYAL CROWN", "item_royal_crown_desc":"Health +30, damage +10%",
		"class_shadow":"SHADOW ALCHEMIST", "class_shadow_desc":"Stronger poison and shields, damage +15%", "night_salt":"NIGHT SALT", "night_salt_short":"SALT", "star_resin":"STAR RESIN", "star_resin_short":"RESIN", "mirror_sap":"MIRROR SAP", "mirror_sap_short":"SAP", "void_thorn":"VOID THORN", "void_thorn_short":"THORN", "poison":"POISON", "shield":"SHIELD",
		"perfect_dodge":"PERFECT DODGE · MANA AND DAMAGE UP", "save_invalid":"SAVE IS DAMAGED", "tutorial":"TUTORIAL", "milestone_reward":"CLAIM REWARD", "reward_item":"NEW ITEM", "reward_upgrade":"UPGRADE", "crown":"ALCHEMY MASTER", "poison_effect":"POISON", "shield_effect":"SHIELD", "new_mix":"NEW MIX", "tutorial_intro":"MIX A POTION, THROW IT AT THE BOSS, AND DODGE ITS ATTACK.", "tutorial_step_0":"LEFT HAND: PICK THE FIRST INGREDIENT", "tutorial_step_1":"RIGHT HAND: PICK THE SECOND INGREDIENT", "tutorial_step_2":"TAP THROW TO HIT THE BOSS", "tutorial_step_3":"WAIT FOR THE ATTACK MARK, THEN SWIPE ASIDE", "tutorial_step_4":"FINISH THE BOSS. DODGING BOOSTED YOUR POTION", "tutorial_done":"TUTORIAL COMPLETE"
	}
}

static func get_text(language: String, key: String) -> String:
	if TEXT.has(language): return TEXT[language].get(key, TEXT["en"].get(key, key))
	var translated: String = Extra.get_text(language, key)
	return translated if translated != "" else TEXT["en"].get(key, key)

static func language_name(language: String) -> String:
	for item in LANGUAGES:
		if item.code == language: return item.name
	return "English"

static func next_language(language: String) -> String:
	for i in range(LANGUAGES.size()):
		if LANGUAGES[i].code == language: return LANGUAGES[(i + 1) % LANGUAGES.size()].code
	return "en"
