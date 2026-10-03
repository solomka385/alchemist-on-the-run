extends RefCounted

const INGREDIENTS = [
	{"key":"moss", "color":"ed9268", "mark":"I"},
	{"key":"dew", "color":"87c8d5", "mark":"II"},
	{"key":"pollen", "color":"e5c97a", "mark":"III"},
	{"key":"bile", "color":"b6d28a", "mark":"IV"},
	{"key":"thorn", "color":"d38bab", "mark":"V"},
	{"key":"echo", "color":"b4a3dc", "mark":"VI"},
	{"key":"ash", "color":"9db4b0", "mark":"VII"},
	{"key":"mercury", "color":"d4d4b6", "mark":"VIII"},
	{"key":"night_salt", "color":"b189d5", "mark":"IX"},
	{"key":"star_resin", "color":"e3b883", "mark":"X"},
	{"key":"mirror_sap", "color":"84c9c2", "mark":"XI"},
	{"key":"void_thorn", "color":"cb7998", "mark":"XII"}
]

const CLASS_LOADOUTS = [[0, 2, 4, 6], [1, 3, 5, 7], [2, 3, 6, 7], [0, 1, 4, 5], [8, 9, 10, 11]]
const HEX = "0123456789AB"

# Pair order never changes the result. All 36 pairs, including doubles, exist.
# key, damage, mana cost, burn damage/sec, burn seconds, slow seconds, pierce, heal
const RECIPES = {
	"00":["wildfire", 22, 18, 8, 4, 0, false, 0],
	"01":["black_ice", 32, 18, 3, 3, 3, false, 0],
	"02":["stormfire", 50, 23, 4, 2, 0, false, 0],
	"03":["caustic_fire", 36, 21, 6, 3, 0, true, 0],
	"04":["blood_ember", 25, 24, 5, 3, 0, false, 8],
	"05":["ember_echo", 20, 20, 12, 4, 0, false, 0],
	"06":["cinder_sleep", 19, 18, 6, 3, 3, false, 0],
	"07":["quicksilver_flame", 39, 23, 5, 4, 0, false, 0],
	"11":["deep_frost", 18, 16, 0, 0, 5, false, 0],
	"12":["static_frost", 38, 20, 0, 0, 3, false, 0],
	"13":["glass_winter", 42, 20, 0, 0, 2, true, 0],
	"14":["red_dew", 10, 32, 0, 0, 2, false, 15],
	"15":["winter_echo", 24, 22, 4, 4, 4, false, 0],
	"16":["sleeping_snow", 15, 18, 0, 0, 6, false, 0],
	"17":["silver_frost", 33, 22, 0, 0, 4, true, 0],
	"22":["thunder", 62, 26, 0, 0, 0, false, 0],
	"23":["lightning_glass", 55, 25, 0, 0, 0, true, 0],
	"24":["living_spark", 32, 26, 0, 0, 0, false, 10],
	"25":["storm_echo", 35, 24, 9, 3, 0, false, 0],
	"26":["silent_storm", 40, 22, 0, 0, 2, false, 0],
	"27":["chain_lightning", 58, 27, 0, 0, 0, true, 0],
	"33":["solvent", 48, 20, 0, 0, 0, true, 0],
	"34":["venom_bloom", 24, 23, 7, 4, 0, true, 5],
	"35":["glass_echo", 30, 23, 6, 3, 0, true, 0],
	"36":["sleeping_acid", 30, 20, 0, 0, 4, true, 0],
	"37":["silver_solvent", 52, 25, 0, 0, 0, true, 0],
	"44":["heartroot", 6, 38, 0, 0, 0, false, 22],
	"45":["living_echo", 18, 29, 3, 4, 0, false, 14],
	"46":["dreamroot", 12, 31, 0, 0, 4, false, 18],
	"47":["silver_blood", 30, 35, 0, 0, 0, true, 15],
	"55":["afterimage", 30, 24, 8, 5, 1, false, 0],
	"56":["dream_echo", 24, 23, 4, 4, 4, false, 0],
	"57":["silver_echo", 42, 25, 7, 3, 0, false, 0],
	"66":["deep_sleep", 9, 19, 0, 0, 7, false, 0],
	"67":["mercury_dream", 38, 23, 0, 0, 5, false, 0],
	"77":["mercury_wave", 60, 27, 0, 0, 0, true, 0]
}

static func recipe(a: int, b: int) -> Dictionary:
	a = clampi(a, 0, INGREDIENTS.size() - 1)
	b = clampi(b, 0, INGREDIENTS.size() - 1)
	var key := HEX[mini(a, b)] + HEX[maxi(a, b)]
	if not RECIPES.has(key):
		var poison := 5.0 + (3.0 if a == 8 and b == 8 else 0.0) if a == 8 or b == 8 else 0.0
		var shield := 12.0 + (7.0 if a == 9 and b == 9 else 0.0) if a == 9 or b == 9 else 0.0
		var stagger_new := 1.1 if a == 10 or b == 10 else 0.0
		var heal_new := 12.0 + (8.0 if a == 11 and b == 11 else 0.0) if a == 11 or b == 11 else 0.0
		return {"id":key, "key":"new_mix", "compound":true, "damage":float(26 + (a + b) % 6 * 5), "cost":float(19 + (a + b) % 5 * 2), "burn":0.0, "duration":4.0, "slow":0.0, "pierce":a == 11 or b == 11, "heal":heal_new, "stagger":stagger_new, "corrode":0.0, "mana_return":10.0 if a == 10 or b == 10 else 0.0, "poison":poison, "shield":shield}
	var r: Array = RECIPES[key]
	var stagger := (0.65 + float(int(key[0]) + int(key[1])) * 0.06) if (a == 2 or b == 2) else 0.0
	var corrode := (2.0 + float(int(key[0]) + int(key[1]))) if (a == 3 or b == 3) else 0.0
	var mana_return := (2.0 + float(int(key[0]) + int(key[1])) * 0.6) if (a == 7 or b == 7) else 0.0
	return {"id":key, "key":r[0], "compound":false, "damage":float(r[1]), "cost":float(r[2]), "burn":float(r[3]), "duration":float(r[4]), "slow":float(r[5]), "pierce":r[6], "heal":float(r[7]), "stagger":stagger, "corrode":corrode, "mana_return":mana_return, "poison":0.0, "shield":0.0}

static func ingredient_index(mark: String) -> int:
	return HEX.find(mark.to_upper())

static func color(index: int) -> Color:
	return Color(INGREDIENTS[index].color)
