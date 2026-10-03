extends RefCounted

const Profile = preload("res://scripts/profile.gd")

# Additional interface translations. Fictional potion and enemy names intentionally
# fall back to the English game lexicon until editorial localization is approved.
const TEXT = {
	"zh": {
		"title":"逃亡炼金术士", "subtitle":"穿越瘟疫之城的最后奔跑", "start":"开始冒险", "continue_run":"继续冒险", "new_run":"新的冒险", "profile":"角色档案", "shop":"炼金商店", "book":"配方书", "settings":"设置", "back":"返回", "resume":"继续", "menu":"主菜单", "health":"生命", "mana":"法力", "wave":"敌人", "boss":"首领", "cast":"混合并投掷", "left":"左手", "right":"右手", "preview":"混合结果", "damage":"伤害", "burn":"燃烧", "slow":"冰冻", "pierce":"破甲", "heal_effect":"治疗", "stagger":"打断", "corrode":"腐蚀", "mana_return":"法力", "level":"等级", "nickname":"炼金术士名字", "choose_avatar":"选择头像", "choose_class":"选择炼金流派", "class":"流派", "reset_profile":"重置档案", "reset_confirm":"删除等级、金币、装备和当前冒险？", "equip":"装备", "equipped":"已装备", "not_enough_coins":"金币不足", "boss_down":"首领已击败", "boss_reward":"休息并选择一项强化", "language":"语言", "audio":"音效", "music":"音乐", "vibration":"震动", "on":"开", "off":"关", "paused":"暂停", "dead":"炼金术士倒下了", "won":"逃出了城市", "again":"再次冒险", "reward":"熔炉营地", "reward_sub":"选择一项强化", "heal":"治疗药剂", "heal_desc":"恢复35点生命", "power":"强烈反应", "power_desc":"药剂伤害+20%", "focus":"第二口气", "focus_desc":"法力+30，恢复更快", "empty":"法力不足——等待或闪避", "dodge_msg":"闪避成功，法力+8", "hit_msg":"受到伤害", "kill_msg":"敌人已击败，法力+14", "discovery":"发现新配方", "book_empty":"首次投掷后解锁配方。", "time":"时间", "score":"击败", "place_sub":"新区域", "choose_left":"选择左手药瓶", "choose_right":"选择右手药瓶", "tap":"点击所选手的材料", "dodge":"左右滑动以闪避"
	},
	"hi": {
		"title":"भागता हुआ कीमियागर", "subtitle":"महामारी के शहर से आख़िरी दौड़", "start":"दौड़ शुरू करें", "continue_run":"दौड़ जारी रखें", "new_run":"नई दौड़", "profile":"प्रोफ़ाइल", "shop":"कीमियागर की दुकान", "book":"नुस्ख़ों की किताब", "settings":"सेटिंग्स", "back":"वापस", "resume":"जारी रखें", "menu":"मुख्य मेनू", "health":"स्वास्थ्य", "mana":"माना", "wave":"शत्रु", "boss":"बॉस", "cast":"मिलाएँ / फेंकें", "left":"बायाँ", "right":"दायाँ", "preview":"मिश्रण का परिणाम", "damage":"क्षति", "burn":"जलन", "slow":"जमाव", "pierce":"कवच", "heal_effect":"उपचार", "stagger":"बाधा", "corrode":"क्षरण", "mana_return":"माना", "level":"स्तर", "nickname":"कीमियागर का नाम", "choose_avatar":"अवतार चुनें", "choose_class":"कीमिया वर्ग चुनें", "class":"वर्ग", "reset_profile":"प्रोफ़ाइल रीसेट", "reset_confirm":"स्तर, सिक्के, सामान और मौजूदा दौड़ मिटाएँ?", "equip":"पहनें", "equipped":"पहना हुआ", "not_enough_coins":"पर्याप्त सिक्के नहीं", "boss_down":"बॉस पराजित", "boss_reward":"आराम करें और सुधार चुनें", "language":"भाषा", "audio":"ध्वनि", "music":"संगीत", "vibration":"कंपन", "on":"चालू", "off":"बंद", "paused":"विराम", "dead":"कीमियागर हार गया", "won":"शहर पीछे छूट गया", "again":"फिर खेलें", "reward":"भट्ठी पर विश्राम", "reward_sub":"एक सुधार चुनें", "heal":"उपचार औषधि", "heal_desc":"35 स्वास्थ्य लौटाएँ", "power":"तीखी प्रतिक्रिया", "power_desc":"औषधि क्षति +20%", "focus":"नई ऊर्जा", "focus_desc":"30 माना और तेज़ पुनर्भरण", "empty":"माना कम है—रुकें या बचें", "dodge_msg":"बचे! +8 माना", "hit_msg":"चोट लगी", "kill_msg":"शत्रु पराजित +14 माना", "discovery":"नया नुस्ख़ा", "book_empty":"पहली बार फेंकने पर नुस्ख़े खुलते हैं।", "time":"समय", "score":"पराजित", "place_sub":"नया स्थान", "choose_left":"बायीं शीशी चुनें", "choose_right":"दायीं शीशी चुनें", "tap":"चुने हुए हाथ की सामग्री छुएँ", "dodge":"बचने के लिए बाएँ या दाएँ स्वाइप करें"
	},
	"es": {
		"title":"ALQUIMISTA EN FUGA", "subtitle":"ÚLTIMA CARRERA POR LA CIUDAD INFECTADA", "start":"EMPEZAR", "continue_run":"CONTINUAR PARTIDA", "new_run":"NUEVA PARTIDA", "profile":"PERFIL", "shop":"TIENDA ALQUÍMICA", "book":"LIBRO DE RECETAS", "settings":"AJUSTES", "back":"VOLVER", "resume":"CONTINUAR", "menu":"MENÚ PRINCIPAL", "health":"SALUD", "mana":"MANÁ", "wave":"ENEMIGO", "boss":"JEFE", "cast":"MEZCLAR / LANZAR", "left":"IZQUIERDA", "right":"DERECHA", "preview":"RESULTADO", "damage":"DAÑO", "burn":"FUEGO", "slow":"HIELO", "pierce":"ARMADURA", "heal_effect":"CURA", "stagger":"INTERRUMPE", "corrode":"CORROE", "mana_return":"MANÁ", "level":"NIVEL", "nickname":"NOMBRE DEL ALQUIMISTA", "choose_avatar":"ELIGE AVATAR", "choose_class":"ELIGE ESCUELA", "class":"ESCUELA", "reset_profile":"BORRAR PERFIL", "reset_confirm":"¿Borrar nivel, monedas, objetos y partida actual?", "equip":"EQUIPAR", "equipped":"EQUIPADO", "not_enough_coins":"FALTAN MONEDAS", "boss_down":"JEFE DERROTADO", "boss_reward":"Descansa y elige una mejora", "language":"IDIOMA", "audio":"SONIDOS", "music":"MÚSICA", "vibration":"VIBRACIÓN", "on":"SÍ", "off":"NO", "paused":"PAUSA", "dead":"EL ALQUIMISTA CAYÓ", "won":"CIUDAD SUPERADA", "again":"OTRA PARTIDA", "reward":"DESCANSO EN EL HORNO", "reward_sub":"Elige una mejora", "heal":"BREBAJE CURATIVO", "heal_desc":"Recupera 35 de salud", "power":"REACCIÓN POTENTE", "power_desc":"Daño de pociones +20%", "focus":"SEGUNDO ALIENTO", "focus_desc":"+30 maná y regeneración", "empty":"SIN MANÁ: ESPERA O ESQUIVA", "dodge_msg":"ESQUIVA +8 MANÁ", "hit_msg":"DAÑO RECIBIDO", "kill_msg":"ENEMIGO CAÍDO +14 MANÁ", "discovery":"NUEVA RECETA", "book_empty":"Descubre recetas al lanzarlas.", "time":"TIEMPO", "score":"DERROTADOS", "place_sub":"NUEVA ZONA", "choose_left":"ELIGE FRASCO IZQUIERDO", "choose_right":"ELIGE FRASCO DERECHO", "tap":"Toca un ingrediente", "dodge":"Desliza para esquivar"
	},
	"ar": {
		"title":"الخيميائي الهارب", "subtitle":"الركضة الأخيرة عبر مدينة الطاعون", "start":"ابدأ الجولة", "continue_run":"تابع الجولة", "new_run":"جولة جديدة", "profile":"الملف الشخصي", "shop":"متجر الخيميائي", "book":"كتاب الوصفات", "settings":"الإعدادات", "back":"رجوع", "resume":"متابعة", "menu":"القائمة الرئيسية", "health":"الصحة", "mana":"المانا", "wave":"العدو", "boss":"الزعيم", "cast":"اخلط وارمِ", "left":"اليسرى", "right":"اليمنى", "preview":"نتيجة المزج", "damage":"الضرر", "burn":"حرق", "slow":"تجميد", "pierce":"الدرع", "heal_effect":"شفاء", "stagger":"إرباك", "corrode":"تآكل", "mana_return":"مانا", "level":"المستوى", "nickname":"اسم الخيميائي", "choose_avatar":"اختر الصورة", "choose_class":"اختر مدرسة الخيمياء", "class":"المدرسة", "reset_profile":"إعادة ضبط الملف", "reset_confirm":"حذف المستوى والعملات والأدوات والجولة الحالية؟", "equip":"تجهيز", "equipped":"مجهّز", "not_enough_coins":"العملات غير كافية", "boss_down":"هُزم الزعيم", "boss_reward":"استرح واختر ترقية", "language":"اللغة", "audio":"الأصوات", "music":"الموسيقى", "vibration":"الاهتزاز", "on":"تشغيل", "off":"إيقاف", "paused":"إيقاف مؤقت", "dead":"سقط الخيميائي", "won":"نجوت من المدينة", "again":"جولة أخرى", "reward":"استراحة عند الفرن", "reward_sub":"اختر ترقية واحدة", "heal":"جرعة شفاء", "heal_desc":"استعد 35 صحة", "power":"تفاعل حاد", "power_desc":"ضرر الجرعات +20%", "focus":"نَفَس ثانٍ", "focus_desc":"+30 مانا وتجدد أسرع", "empty":"المانا قليلة؛ انتظر أو تفادَ", "dodge_msg":"تفادٍ +8 مانا", "hit_msg":"تلقيت ضررًا", "kill_msg":"هُزم العدو +14 مانا", "discovery":"وصفة جديدة", "book_empty":"تُفتح الوصفات عند رميها أول مرة.", "time":"الوقت", "score":"المهزومون", "place_sub":"منطقة جديدة", "choose_left":"اختر قارورة اليد اليسرى", "choose_right":"اختر قارورة اليد اليمنى", "tap":"المس مكوّن اليد المختارة", "dodge":"اسحب جانبًا لتتفادى"
	},
	"fr": {
		"title":"ALCHIMISTE EN FUITE", "subtitle":"DERNIÈRE COURSE DANS LA CITÉ PESTIFÉRÉE", "start":"COMMENCER", "continue_run":"REPRENDRE LA PARTIE", "new_run":"NOUVELLE PARTIE", "profile":"PROFIL", "shop":"BOUTIQUE D'ALCHIMIE", "book":"LIVRE DE RECETTES", "settings":"PARAMÈTRES", "back":"RETOUR", "resume":"REPRENDRE", "menu":"MENU PRINCIPAL", "health":"SANTÉ", "mana":"MANA", "wave":"ENNEMI", "boss":"BOSS", "cast":"MÉLANGER / LANCER", "left":"GAUCHE", "right":"DROITE", "preview":"RÉSULTAT", "damage":"DÉGÂTS", "burn":"BRÛLURE", "slow":"GEL", "pierce":"ARMURE", "heal_effect":"SOIN", "stagger":"DÉSTABILISE", "corrode":"CORROSION", "mana_return":"MANA", "level":"NIVEAU", "nickname":"NOM DE L'ALCHIMISTE", "choose_avatar":"CHOISIR UN AVATAR", "choose_class":"CHOISIR UNE ÉCOLE", "class":"ÉCOLE", "reset_profile":"RÉINITIALISER", "reset_confirm":"Effacer niveau, pièces, objets et partie en cours ?", "equip":"ÉQUIPER", "equipped":"ÉQUIPÉ", "not_enough_coins":"PIÈCES INSUFFISANTES", "boss_down":"BOSS VAINCU", "boss_reward":"Reposez-vous et choisissez un bonus", "language":"LANGUE", "audio":"EFFETS SONORES", "music":"MUSIQUE", "vibration":"VIBRATION", "on":"OUI", "off":"NON", "paused":"PAUSE", "dead":"L'ALCHIMISTE EST TOMBÉ", "won":"LA CITÉ EST DERRIÈRE VOUS", "again":"REJOUER", "reward":"HALTE AU FOURNEAU", "reward_sub":"Choisissez un bonus", "heal":"BREUVAGE DE SOIN", "heal_desc":"Restaure 35 points de vie", "power":"RÉACTION VIVE", "power_desc":"Dégâts des potions +20 %", "focus":"SECOND SOUFFLE", "focus_desc":"+30 mana et recharge rapide", "empty":"MANA INSUFFISANT : ATTENDEZ OU ESQUIVEZ", "dodge_msg":"ESQUIVE +8 MANA", "hit_msg":"DÉGÂTS SUBIS", "kill_msg":"ENNEMI VAINCU +14 MANA", "discovery":"NOUVELLE RECETTE", "book_empty":"Les recettes se découvrent au premier lancer.", "time":"TEMPS", "score":"VAINCUS", "place_sub":"NOUVEAU LIEU", "choose_left":"CHOISISSEZ LA FIOLE GAUCHE", "choose_right":"CHOISISSEZ LA FIOLE DROITE", "tap":"Touchez un ingrédient", "dodge":"Glissez pour esquiver"
	},
	"bn": {
		"title":"পলাতক রসায়নবিদ", "subtitle":"মহামারির শহরে শেষ দৌড়", "start":"দৌড় শুরু", "continue_run":"দৌড় চালিয়ে যান", "new_run":"নতুন দৌড়", "profile":"প্রোফাইল", "shop":"রসায়নের দোকান", "book":"সূত্রের বই", "settings":"সেটিংস", "back":"ফিরে যান", "resume":"চালিয়ে যান", "menu":"মূল মেনু", "health":"স্বাস্থ্য", "mana":"মানা", "wave":"শত্রু", "boss":"বস", "cast":"মেশান / ছুড়ুন", "left":"বাঁ", "right":"ডান", "preview":"মিশ্রণের ফল", "damage":"ক্ষতি", "burn":"আগুন", "slow":"বরফ", "pierce":"বর্ম", "heal_effect":"আরোগ্য", "stagger":"বাধা", "corrode":"ক্ষয়", "mana_return":"মানা", "level":"স্তর", "nickname":"রসায়নবিদের নাম", "choose_avatar":"অবতার বাছুন", "choose_class":"রসায়নের ধারা বাছুন", "class":"ধারা", "reset_profile":"প্রোফাইল মুছুন", "reset_confirm":"স্তর, মুদ্রা, সরঞ্জাম ও বর্তমান দৌড় মুছবেন?", "equip":"পরুন", "equipped":"পরা আছে", "not_enough_coins":"মুদ্রা যথেষ্ট নয়", "boss_down":"বস পরাজিত", "boss_reward":"বিশ্রাম নিন ও উন্নতি বাছুন", "language":"ভাষা", "audio":"শব্দ", "music":"সংগীত", "vibration":"কম্পন", "on":"চালু", "off":"বন্ধ", "paused":"বিরতি", "dead":"রসায়নবিদ পরাজিত", "won":"শহর পেরিয়েছেন", "again":"আবার খেলুন", "reward":"চুল্লির পাশে বিশ্রাম", "reward_sub":"একটি উন্নতি বাছুন", "heal":"আরোগ্য পানীয়", "heal_desc":"৩৫ স্বাস্থ্য ফেরায়", "power":"তীব্র বিক্রিয়া", "power_desc":"ঔষধের ক্ষতি +২০%", "focus":"নতুন শক্তি", "focus_desc":"+৩০ মানা ও দ্রুত পুনরুদ্ধার", "empty":"মানা কম—অপেক্ষা বা এড়িয়ে যান", "dodge_msg":"এড়িয়েছেন +৮ মানা", "hit_msg":"আঘাত পেয়েছেন", "kill_msg":"শত্রু পরাজিত +১৪ মানা", "discovery":"নতুন সূত্র", "book_empty":"প্রথমবার ছুড়লে সূত্র খুলবে।", "time":"সময়", "score":"পরাজিত", "place_sub":"নতুন এলাকা", "choose_left":"বাঁ হাতের শিশি বাছুন", "choose_right":"ডান হাতের শিশি বাছুন", "tap":"বাছা হাতের উপাদান ছুঁন", "dodge":"এড়াতে পাশে সোয়াইপ করুন"
	},
	"pt": {
		"title":"ALQUIMISTA EM FUGA", "subtitle":"ÚLTIMA CORRIDA PELA CIDADE DA PESTE", "start":"COMEÇAR", "continue_run":"CONTINUAR PARTIDA", "new_run":"NOVA PARTIDA", "profile":"PERFIL", "shop":"LOJA DO ALQUIMISTA", "book":"LIVRO DE RECEITAS", "settings":"CONFIGURAÇÕES", "back":"VOLTAR", "resume":"CONTINUAR", "menu":"MENU PRINCIPAL", "health":"VIDA", "mana":"MANA", "wave":"INIMIGO", "boss":"CHEFE", "cast":"MISTURAR / LANÇAR", "left":"ESQUERDA", "right":"DIREITA", "preview":"RESULTADO", "damage":"DANO", "burn":"QUEIMAR", "slow":"GELO", "pierce":"ARMADURA", "heal_effect":"CURA", "stagger":"ATORDOA", "corrode":"CORRÓI", "mana_return":"MANA", "level":"NÍVEL", "nickname":"NOME DO ALQUIMISTA", "choose_avatar":"ESCOLHER AVATAR", "choose_class":"ESCOLHER ESCOLA", "class":"ESCOLA", "reset_profile":"REDEFINIR PERFIL", "reset_confirm":"Apagar nível, moedas, itens e partida atual?", "equip":"EQUIPAR", "equipped":"EQUIPADO", "not_enough_coins":"MOEDAS INSUFICIENTES", "boss_down":"CHEFE DERROTADO", "boss_reward":"Descanse e escolha uma melhoria", "language":"IDIOMA", "audio":"EFEITOS SONOROS", "music":"MÚSICA", "vibration":"VIBRAÇÃO", "on":"LIGADO", "off":"DESLIGADO", "paused":"PAUSA", "dead":"O ALQUIMISTA CAIU", "won":"A CIDADE FICOU PARA TRÁS", "again":"JOGAR DE NOVO", "reward":"DESCANSO NA FORNALHA", "reward_sub":"Escolha uma melhoria", "heal":"POÇÃO DE CURA", "heal_desc":"Recupera 35 de vida", "power":"REAÇÃO FORTE", "power_desc":"Dano de poções +20%", "focus":"SEGUNDO FÔLEGO", "focus_desc":"+30 mana e recuperação", "empty":"SEM MANA: ESPERE OU DESVIE", "dodge_msg":"DESVIO +8 MANA", "hit_msg":"DANO RECEBIDO", "kill_msg":"INIMIGO DERROTADO +14 MANA", "discovery":"NOVA RECEITA", "book_empty":"Receitas aparecem após o primeiro uso.", "time":"TEMPO", "score":"DERROTADOS", "place_sub":"NOVA ÁREA", "choose_left":"ESCOLHA O FRASCO ESQUERDO", "choose_right":"ESCOLHA O FRASCO DIREITO", "tap":"Toque em um ingrediente", "dodge":"Deslize para desviar"
	},
	"ur": {
		"title":"بھاگتا ہوا کیمیاگر", "subtitle":"وبا زدہ شہر سے آخری دوڑ", "start":"دوڑ شروع کریں", "continue_run":"دوڑ جاری رکھیں", "new_run":"نئی دوڑ", "profile":"پروفائل", "shop":"کیمیاگر کی دکان", "book":"نسخوں کی کتاب", "settings":"ترتیبات", "back":"واپس", "resume":"جاری رکھیں", "menu":"مرکزی مینو", "health":"صحت", "mana":"مانا", "wave":"دشمن", "boss":"باس", "cast":"ملائیں / پھینکیں", "left":"بایاں", "right":"دایاں", "preview":"آمیزے کا نتیجہ", "damage":"نقصان", "burn":"جلنا", "slow":"جمنا", "pierce":"زرہ", "heal_effect":"شفا", "stagger":"خلل", "corrode":"کھرچ", "mana_return":"مانا", "level":"درجہ", "nickname":"کیمیاگر کا نام", "choose_avatar":"تصویر چنیں", "choose_class":"کیمیا کا شعبہ چنیں", "class":"شعبہ", "reset_profile":"پروفائل مٹائیں", "reset_confirm":"درجہ، سکے، سامان اور موجودہ دوڑ مٹائیں؟", "equip":"پہنیں", "equipped":"پہنا ہوا", "not_enough_coins":"سکے ناکافی ہیں", "boss_down":"باس شکست کھا گیا", "boss_reward":"آرام کریں اور بہتری چنیں", "language":"زبان", "audio":"آواز", "music":"موسیقی", "vibration":"لرزش", "on":"چالو", "off":"بند", "paused":"وقفہ", "dead":"کیمیاگر گر گیا", "won":"شہر پیچھے رہ گیا", "again":"دوبارہ کھیلیں", "reward":"بھٹی کے پاس آرام", "reward_sub":"ایک بہتری چنیں", "heal":"شفائی مشروب", "heal_desc":"35 صحت بحال", "power":"تیز تعامل", "power_desc":"دواؤں کا نقصان +20%", "focus":"دوسری سانس", "focus_desc":"+30 مانا، تیز بحالی", "empty":"مانا کم ہے—انتظار یا بچاؤ", "dodge_msg":"بچاؤ +8 مانا", "hit_msg":"نقصان ہوا", "kill_msg":"دشمن شکست خوردہ +14 مانا", "discovery":"نیا نسخہ", "book_empty":"پہلی بار پھینکنے پر نسخے کھلتے ہیں۔", "time":"وقت", "score":"شکست خوردہ", "place_sub":"نئی جگہ", "choose_left":"بائیں ہاتھ کی شیشی چنیں", "choose_right":"دائیں ہاتھ کی شیشی چنیں", "tap":"چنے ہوئے ہاتھ کا جزو دبائیں", "dodge":"بچنے کے لیے پہلو میں سوائپ کریں"
	},
	"id": {
		"title":"ALKE­MIS DALAM PELARIAN", "subtitle":"LARI TERAKHIR MELINTASI KOTA WABAH", "start":"MULAI", "continue_run":"LANJUTKAN", "new_run":"PERMAINAN BARU", "profile":"PROFIL", "shop":"TOKO ALKIMIA", "book":"BUKU RESEP", "settings":"PENGATURAN", "back":"KEMBALI", "resume":"LANJUTKAN", "menu":"MENU UTAMA", "health":"NYAWA", "mana":"MANA", "wave":"MUSUH", "boss":"BOS", "cast":"CAMPUR / LEMPAR", "left":"KIRI", "right":"KANAN", "preview":"HASIL CAMPURAN", "damage":"KERUSAKAN", "burn":"BAKAR", "slow":"BEKU", "pierce":"ZIRAH", "heal_effect":"SEMBUH", "stagger":"GUNCANG", "corrode":"KOROSI", "mana_return":"MANA", "level":"LEVEL", "nickname":"NAMA ALKEMIS", "choose_avatar":"PILIH AVATAR", "choose_class":"PILIH ALIRAN", "class":"ALIRAN", "reset_profile":"RESET PROFIL", "reset_confirm":"Hapus level, koin, perlengkapan, dan permainan ini?", "equip":"PAKAI", "equipped":"DIPAKAI", "not_enough_coins":"KOIN TIDAK CUKUP", "boss_down":"BOS DIKALAHKAN", "boss_reward":"Istirahat dan pilih peningkatan", "language":"BAHASA", "audio":"EFEK SUARA", "music":"MUSIK", "vibration":"GETARAN", "on":"HIDUP", "off":"MATI", "paused":"JEDA", "dead":"ALKEMIS GUGUR", "won":"KOTA TELAH DILEWATI", "again":"MAIN LAGI", "reward":"ISTIRAHAT DI TUNGKU", "reward_sub":"Pilih satu peningkatan", "heal":"RAMUAN PENYEMBUH", "heal_desc":"Pulihkan 35 nyawa", "power":"REAKSI TAJAM", "power_desc":"Kerusakan ramuan +20%", "focus":"NAPAS KEDUA", "focus_desc":"+30 mana, pulih lebih cepat", "empty":"MANA KURANG—TUNGGU ATAU HINDAR", "dodge_msg":"HINDAR +8 MANA", "hit_msg":"TERKENA SERANGAN", "kill_msg":"MUSUH KALAH +14 MANA", "discovery":"RESEP BARU", "book_empty":"Resep terbuka setelah lemparan pertama.", "time":"WAKTU", "score":"DIKALAHKAN", "place_sub":"LOKASI BARU", "choose_left":"PILIH BOTOL KIRI", "choose_right":"PILIH BOTOL KANAN", "tap":"Ketuk bahan untuk tangan terpilih", "dodge":"Geser ke samping untuk menghindar"
	},
	"de": {
		"title":"ALCHEMIST AUF DER FLUCHT", "subtitle":"DER LETZTE LAUF DURCH DIE PESTSTADT", "start":"LAUF STARTEN", "continue_run":"LAUF FORTSETZEN", "new_run":"NEUER LAUF", "profile":"PROFIL", "shop":"ALCHEMISTENLADEN", "book":"REZEPTBUCH", "settings":"EINSTELLUNGEN", "back":"ZURÜCK", "resume":"FORTSETZEN", "menu":"HAUPTMENÜ", "health":"LEBEN", "mana":"MANA", "wave":"GEGNER", "boss":"BOSS", "cast":"MISCHEN / WERFEN", "left":"LINKS", "right":"RECHTS", "preview":"MISCHERGEBNIS", "damage":"SCHADEN", "burn":"BRAND", "slow":"FROST", "pierce":"RÜSTUNG", "heal_effect":"HEILUNG", "stagger":"UNTERBRICHT", "corrode":"ZERSETZT", "mana_return":"MANA", "level":"STUFE", "nickname":"NAME DES ALCHEMISTEN", "choose_avatar":"AVATAR WÄHLEN", "choose_class":"SCHULE WÄHLEN", "class":"SCHULE", "reset_profile":"PROFIL ZURÜCKSETZEN", "reset_confirm":"Stufe, Münzen, Ausrüstung und Lauf löschen?", "equip":"ANLEGEN", "equipped":"ANGELEGT", "not_enough_coins":"ZU WENIG MÜNZEN", "boss_down":"BOSS BESIEGT", "boss_reward":"Rasten und Verbesserung wählen", "language":"SPRACHE", "audio":"GERÄUSCHE", "music":"MUSIK", "vibration":"VIBRATION", "on":"AN", "off":"AUS", "paused":"PAUSE", "dead":"ALCHEMIST GEFALLEN", "won":"STADT HINTER DIR", "again":"NOCH EIN LAUF", "reward":"RAST AM OFEN", "reward_sub":"Wähle eine Verbesserung", "heal":"HEILTRANK", "heal_desc":"Heilt 35 Leben", "power":"SCHARFE REAKTION", "power_desc":"Trankschaden +20%", "focus":"ZWEITER ATEM", "focus_desc":"+30 Mana und schnellere Erholung", "empty":"ZU WENIG MANA—WARTEN ODER AUSWEICHEN", "dodge_msg":"AUSGEWICHEN +8 MANA", "hit_msg":"SCHADEN ERLITTEN", "kill_msg":"GEGNER BESIEGT +14 MANA", "discovery":"NEUES REZEPT", "book_empty":"Rezepte werden beim ersten Wurf entdeckt.", "time":"ZEIT", "score":"BESIEGT", "place_sub":"NEUER ORT", "choose_left":"LINKE PHIOLE WÄHLEN", "choose_right":"RECHTE PHIOLE WÄHLEN", "tap":"Zutat für gewählte Hand tippen", "dodge":"Seitlich wischen zum Ausweichen"
	},
	"ja": {
		"title":"逃亡の錬金術師", "subtitle":"疫病の街を駆け抜ける最後の旅", "start":"開始", "continue_run":"続きから", "new_run":"新しい冒険", "profile":"プロフィール", "shop":"錬金術の店", "book":"調合図鑑", "settings":"設定", "back":"戻る", "resume":"再開", "menu":"メインメニュー", "health":"体力", "mana":"マナ", "wave":"敵", "boss":"ボス", "cast":"調合して投げる", "left":"左手", "right":"右手", "preview":"調合結果", "damage":"ダメージ", "burn":"炎上", "slow":"凍結", "pierce":"装甲", "heal_effect":"回復", "stagger":"妨害", "corrode":"腐食", "mana_return":"マナ", "level":"レベル", "nickname":"錬金術師の名前", "choose_avatar":"アバターを選択", "choose_class":"流派を選択", "class":"流派", "reset_profile":"プロフィール初期化", "reset_confirm":"レベル、コイン、装備、進行中の冒険を削除しますか？", "equip":"装備", "equipped":"装備中", "not_enough_coins":"コインが足りません", "boss_down":"ボス撃破", "boss_reward":"休憩して強化を選ぼう", "language":"言語", "audio":"効果音", "music":"音楽", "vibration":"振動", "on":"オン", "off":"オフ", "paused":"一時停止", "dead":"錬金術師は倒れた", "won":"街を脱出した", "again":"もう一度", "reward":"炉で休憩", "reward_sub":"強化を一つ選択", "heal":"回復薬", "heal_desc":"体力を35回復", "power":"強い反応", "power_desc":"薬のダメージ+20%", "focus":"新たな息吹", "focus_desc":"マナ+30、回復速度上昇", "empty":"マナ不足—待つか回避", "dodge_msg":"回避 マナ+8", "hit_msg":"ダメージを受けた", "kill_msg":"敵を撃破 マナ+14", "discovery":"新しい調合", "book_empty":"初めて投げると調合が解放されます。", "time":"時間", "score":"撃破数", "place_sub":"新しい場所", "choose_left":"左手の瓶を選択", "choose_right":"右手の瓶を選択", "tap":"選んだ手の素材をタップ", "dodge":"横にスワイプして回避"
	},
	"pcm": {
		"title":"ALCHEMIST WEY DEY RUN", "subtitle":"LAST RUN THROUGH DI PLAGUE CITY", "start":"START RUN", "continue_run":"CONTINUE RUN", "new_run":"NEW RUN", "profile":"PROFILE", "shop":"ALCHEMIST SHOP", "book":"RECIPE BOOK", "settings":"SETTINGS", "back":"GO BACK", "resume":"CONTINUE", "menu":"MAIN MENU", "health":"LIFE", "mana":"MANA", "wave":"ENEMY", "boss":"BOSS", "cast":"MIX AM / THROW AM", "left":"LEFT", "right":"RIGHT", "preview":"WETIN YOU MIX", "damage":"DAMAGE", "burn":"FIRE", "slow":"FREEZE", "pierce":"ARMOR", "heal_effect":"HEAL", "stagger":"SHAKE", "corrode":"CORRODE", "mana_return":"MANA", "level":"LEVEL", "nickname":"ALCHEMIST NAME", "choose_avatar":"PICK AVATAR", "choose_class":"PICK ALCHEMY STYLE", "class":"STYLE", "reset_profile":"RESET PROFILE", "reset_confirm":"Clear level, coins, gear and dis run?", "equip":"WEAR AM", "equipped":"YOU DEY WEAR AM", "not_enough_coins":"COINS NO REACH", "boss_down":"BOSS DON FALL", "boss_reward":"Rest small, pick upgrade", "language":"LANGUAGE", "audio":"SOUND", "music":"MUSIC", "vibration":"VIBRATION", "on":"ON", "off":"OFF", "paused":"PAUSE", "dead":"ALCHEMIST DON FALL", "won":"YOU DON PASS DI CITY", "again":"RUN AGAIN", "reward":"REST FOR FURNACE", "reward_sub":"Pick one upgrade", "heal":"HEALING DRINK", "heal_desc":"Bring back 35 life", "power":"STRONG REACTION", "power_desc":"Potion damage +20%", "focus":"SECOND BREATH", "focus_desc":"+30 mana, quick recovery", "empty":"MANA NO REACH—WAIT OR DODGE", "dodge_msg":"DODGE +8 MANA", "hit_msg":"DEM HIT YOU", "kill_msg":"ENEMY DON FALL +14 MANA", "discovery":"NEW RECIPE", "book_empty":"Recipe go open first time you throw am.", "time":"TIME", "score":"ENEMIES WEY FALL", "place_sub":"NEW PLACE", "choose_left":"PICK LEFT BOTTLE", "choose_right":"PICK RIGHT BOTTLE", "tap":"Touch ingredient for chosen hand", "dodge":"Swipe side to dodge"
	},
	"arz": {
		"title":"الخيميائي الهربان", "subtitle":"آخر جري في مدينة الوباء", "start":"ابدأ الجولة", "continue_run":"كمّل الجولة", "new_run":"جولة جديدة", "profile":"الملف", "shop":"دكان الخيميائي", "book":"كتاب الخلطات", "settings":"الإعدادات", "back":"ارجع", "resume":"كمّل", "menu":"القائمة الرئيسية", "health":"الصحة", "mana":"المانا", "wave":"العدو", "boss":"الزعيم", "cast":"اخلط وارمي", "left":"الشمال", "right":"اليمين", "preview":"نتيجة الخلطة", "damage":"الضرر", "burn":"حرق", "slow":"تجميد", "pierce":"درع", "heal_effect":"علاج", "stagger":"تعطيل", "corrode":"تآكل", "mana_return":"مانا", "level":"المستوى", "nickname":"اسم الخيميائي", "choose_avatar":"اختار الصورة", "choose_class":"اختار مدرسة الخيمياء", "class":"المدرسة", "reset_profile":"امسح الملف", "reset_confirm":"تمسح المستوى والفلوس والحاجات والجولة؟", "equip":"البس", "equipped":"ملبوس", "not_enough_coins":"الفلوس مش كفاية", "boss_down":"الزعيم اتهزم", "boss_reward":"ارتاح واختار تطوير", "language":"اللغة", "audio":"الأصوات", "music":"المزيكا", "vibration":"الاهتزاز", "on":"شغال", "off":"مقفول", "paused":"توقّف", "dead":"الخيميائي وقع", "won":"عدّيت المدينة", "again":"العب تاني", "reward":"راحة عند الفرن", "reward_sub":"اختار تطوير واحد", "heal":"مشروب علاج", "heal_desc":"يرجع 35 صحة", "power":"تفاعل قوي", "power_desc":"ضرر الجرعات +20%", "focus":"نَفَس جديد", "focus_desc":"+30 مانا وتجدد أسرع", "empty":"المانا قليلة—استنى أو اهرب", "dodge_msg":"تفادي +8 مانا", "hit_msg":"اتضربت", "kill_msg":"العدو اتهزم +14 مانا", "discovery":"خلطة جديدة", "book_empty":"الخلطات بتظهر أول ما ترميها.", "time":"الوقت", "score":"المهزومين", "place_sub":"مكان جديد", "choose_left":"اختار إزازة الشمال", "choose_right":"اختار إزازة اليمين", "tap":"اضغط على مكوّن الإيد", "dodge":"اسحب على الجنب عشان تتفادى"
	}
}

const NEW_UI_KEYS = ["tutorial", "milestone_reward", "reward_item", "reward_upgrade", "poison_effect", "shield_effect", "new_mix", "tutorial_step_0", "tutorial_step_1", "tutorial_step_2", "tutorial_step_3", "tutorial_step_4"]
const NEW_UI = {
	"zh":["教程","领取奖励","新物品","升级","中毒","护盾","新混合物","左手：选择第一种材料","右手：选择第二种材料","点击投掷攻击首领","等待攻击标记，向旁边滑动","击败首领：闪避强化药剂"],
	"hi":["प्रशिक्षण","इनाम लें","नई वस्तु","उन्नयन","ज़हर","ढाल","नया मिश्रण","बायाँ हाथ: पहली सामग्री चुनें","दायाँ हाथ: दूसरी सामग्री चुनें","बॉस को मारने के लिए फेंकें","हमले का निशान देखें, फिर स्वाइप करें","बॉस को हराएँ; बचाव से औषधि मजबूत हुई"],
	"es":["TUTORIAL","RECOGER PREMIO","OBJETO NUEVO","MEJORA","VENENO","ESCUDO","MEZCLA NUEVA","MANO IZQUIERDA: ELIGE EL PRIMER INGREDIENTE","MANO DERECHA: ELIGE EL SEGUNDO INGREDIENTE","LANZA LA POCIÓN AL JEFE","ESPERA LA MARCA Y DESLIZA A UN LADO","REMATA AL JEFE; ESQUIVAR POTENCIA LA POCIÓN"],
	"ar":["تدريب","استلم المكافأة","عنصر جديد","ترقية","سم","درع","مزيج جديد","اليد اليسرى: اختر المكوّن الأول","اليد اليمنى: اختر المكوّن الثاني","ارمِ الجرعة على الزعيم","انتظر علامة الهجوم ثم اسحب جانبًا","اهزم الزعيم؛ المراوغة تقوّي الجرعة"],
	"fr":["TUTORIEL","RÉCUPÉRER LA RÉCOMPENSE","NOUVEL OBJET","AMÉLIORATION","POISON","BOUCLIER","NOUVEAU MÉLANGE","MAIN GAUCHE : CHOISISSEZ LE PREMIER INGRÉDIENT","MAIN DROITE : CHOISISSEZ LE SECOND INGRÉDIENT","LANCEZ LA POTION SUR LE BOSS","ATTENDEZ LA MARQUE, PUIS GLISSEZ SUR LE CÔTÉ","ACHEVEZ LE BOSS ; L'ESQUIVE RENFORCE LA POTION"],
	"bn":["প্রশিক্ষণ","পুরস্কার নিন","নতুন বস্তু","উন্নতি","বিষ","ঢাল","নতুন মিশ্রণ","বাঁ হাতে প্রথম উপাদান বাছুন","ডান হাতে দ্বিতীয় উপাদান বাছুন","বসকে আঘাত করতে পানীয় ছুড়ুন","আক্রমণের চিহ্ন দেখে পাশে সোয়াইপ করুন","বসকে হারান; এড়ানো পানীয় শক্তিশালী করে"],
	"pt":["TUTORIAL","RESGATAR PRÊMIO","ITEM NOVO","MELHORIA","VENENO","ESCUDO","NOVA MISTURA","MÃO ESQUERDA: ESCOLHA O PRIMEIRO INGREDIENTE","MÃO DIREITA: ESCOLHA O SEGUNDO INGREDIENTE","LANCE A POÇÃO NO CHEFE","ESPERE A MARCA E DESLIZE PARA O LADO","DERROTE O CHEFE; DESVIAR FORTALECE A POÇÃO"],
	"ur":["تربیت","انعام لیں","نئی چیز","بہتری","زہر","ڈھال","نیا آمیزہ","بائیں ہاتھ کے لیے پہلا جزو چنیں","دائیں ہاتھ کے لیے دوسرا جزو چنیں","باس پر شیشی پھینکیں","حملے کا نشان دیکھ کر پہلو میں سوائپ کریں","باس کو ہرائیں؛ بچاؤ سے شیشی مضبوط ہوئی"],
	"id":["TUTORIAL","AMBIL HADIAH","BARANG BARU","PENINGKATAN","RACUN","PERISAI","CAMPURAN BARU","TANGAN KIRI: PILIH BAHAN PERTAMA","TANGAN KANAN: PILIH BAHAN KEDUA","LEMPARKAN RAMUAN KE BOS","TUNGGU TANDA SERANGAN, LALU GESER","KALAHKAN BOS; HINDAR MEMPERKUAT RAMUAN"],
	"de":["ANLEITUNG","BELOHNUNG ABHOLEN","NEUER GEGENSTAND","VERBESSERUNG","GIFT","SCHILD","NEUE MISCHUNG","LINKE HAND: ERSTE ZUTAT WÄHLEN","RECHTE HAND: ZWEITE ZUTAT WÄHLEN","TRANK AUF DEN BOSS WERFEN","AUF ANGRIFFSMARKE WARTEN, DANN WISCHEN","BOSS BESIEGEN; AUSWEICHEN STÄRKT DEN TRANK"],
	"ja":["チュートリアル","報酬を受け取る","新しい装備","強化","毒","盾","新しい調合","左手：最初の素材を選ぶ","右手：次の素材を選ぶ","薬を投げてボスを攻撃","攻撃の印を待ち、横にスワイプ","ボスを倒そう。回避で薬が強くなる"],
	"pcm":["LEARN HOW TO PLAY","COLLECT REWARD","NEW ITEM","UPGRADE","POISON","SHIELD","NEW MIX","LEFT HAND: PICK FIRST INGREDIENT","RIGHT HAND: PICK SECOND INGREDIENT","THROW POTION HIT BOSS","WAIT FOR ATTACK MARK, SWIPE SIDE","BEAT BOSS; DODGE MAKE POTION STRONG"],
	"arz":["تعليم","خد المكافأة","حاجة جديدة","تطوير","سم","درع","خلطة جديدة","الإيد الشمال: اختار أول مكوّن","الإيد اليمين: اختار تاني مكوّن","ارمي الجرعة على الزعيم","استنى علامة الهجوم واسحب على الجنب","اهزم الزعيم؛ التفادي قوّى الجرعة"]
}

const LEVEL_TEXT = {
	"zh":["升级", "力量与生命提升", "等级加成"],
	"hi":["स्तर बढ़ा", "शक्ति और स्वास्थ्य बढ़े", "स्तर बोनस"],
	"es":["SUBE DE NIVEL", "AUMENTAN PODER Y SALUD", "BONO DE NIVEL"],
	"ar":["ارتفع المستوى", "زادت القوة والصحة", "مكافأة المستوى"],
	"fr":["NIVEAU SUPÉRIEUR", "PUISSANCE ET SANTÉ AUGMENTÉES", "BONUS DE NIVEAU"],
	"bn":["স্তর বেড়েছে", "শক্তি ও স্বাস্থ্য বেড়েছে", "স্তরের বোনাস"],
	"pt":["SUBIU DE NÍVEL", "PODER E VIDA AUMENTARAM", "BÔNUS DE NÍVEL"],
	"ur":["درجہ بڑھ گیا", "طاقت اور صحت میں اضافہ", "درجے کا بونس"],
	"id":["NAIK LEVEL", "KEKUATAN DAN NYAWA NAIK", "BONUS LEVEL"],
	"de":["STUFE AUFGESTIEGEN", "KRAFT UND LEBEN GESTIEGEN", "STUFENBONUS"],
	"ja":["レベルアップ", "攻撃力と体力が上昇", "レベルボーナス"],
	"pcm":["LEVEL DON GO UP", "POWER AND LIFE DON INCREASE", "LEVEL BONUS"],
	"arz":["المستوى زاد", "القوة والصحة زادوا", "زيادة المستوى"]
}

const EXPANSION_UI = {
	"zh":["敌人已击败", "下一个敌人正在接近", "点物品装备；点箭头升级，每级加成提高25%", "满级"],
	"hi":["शत्रु पराजित", "अगला शत्रु आ रहा है", "वस्तु पहनें; तीर से सुधारें, हर स्तर पर +25%", "अधिकतम"],
	"es":["ENEMIGO DERROTADO", "SE ACERCA OTRO ENEMIGO", "Toca el objeto para equipar; flecha para mejorar (+25%/nivel)", "MÁX."],
	"ar":["هُزم العدو", "العدو التالي يقترب", "اضغط للتجهيز، والسهم للترقية (+25٪ لكل مستوى)", "الأقصى"],
	"fr":["ENNEMI VAINCU", "LE PROCHAIN ENNEMI APPROCHE", "Objet : équiper ; flèche : améliorer (+25 %/niveau)", "MAX"],
	"bn":["শত্রু পরাজিত", "পরের শত্রু আসছে", "সাজাতে বস্তুতে চাপুন; উন্নতির জন্য তীর (+২৫%/স্তর)", "সর্বোচ্চ"],
	"pt":["INIMIGO DERROTADO", "PRÓXIMO INIMIGO SE APROXIMA", "Toque para equipar; seta para melhorar (+25%/nível)", "MÁX."],
	"ur":["دشمن شکست کھا گیا", "اگلا دشمن آ رہا ہے", "پہننے کے لیے چیز، بہتر کرنے کے لیے تیر (+25٪ فی درجہ)", "آخری"],
	"id":["MUSUH DIKALAHKAN", "MUSUH BERIKUTNYA MENDEKAT", "Ketuk barang untuk pakai; panah untuk naikkan (+25%/level)", "MAKS"],
	"de":["GEGNER BESIEGT", "NÄCHSTER GEGNER NAHT", "Gegenstand anlegen; Pfeil verbessern (+25 %/Stufe)", "MAX"],
	"ja":["敵を倒した", "次の敵が近づく", "装備は品物、強化は矢印（各段階+25%）", "最大"],
	"pcm":["ENEMY DON FALL", "NEXT ENEMY DEY COME", "Tap item wear am; arrow upgrade am (+25% each level)", "MAX"],
	"arz":["العدو اتهزم", "العدو اللي بعده جاي", "اضغط على الحاجة تلبسها، والسهم تطورها (+25٪ لكل مستوى)", "آخر مستوى"]
}

const CLASS_KEYS = ["ember", "frost", "storm", "vital", "shadow"]
const ITEM_KEYS = ["hood", "crown", "gloves", "gauntlets", "vial", "heart", "ash_boots", "frost_boots", "ember_ring", "mercury_ring", "plague_mask", "raven_mask", "copper_belt", "storm_belt", "glass_amulet", "eclipse_amulet", "ward_lantern", "transfusion", "dodge_boots", "royal_crown"]
const SLOT_KEYS = ["head", "hands", "charm", "feet", "ring", "face", "belt"]
const CLASS_NAMES = {
	"zh":["烈焰炼金术士","寒霜炼金术士","风暴炼金术士","生命炼金术士","暗影炼金术士"],
	"hi":["अग्नि कीमियागर","हिम कीमियागर","तूफ़ान कीमियागर","जीवन कीमियागर","छाया कीमियागर"],
	"es":["PIROALQUIMISTA","CRIOALQUIMISTA","ALQUIMISTA DE TORMENTA","VITALISTA","ALQUIMISTA SOMBRÍO"],
	"ar":["خيميائي النار","خيميائي الجليد","خيميائي العاصفة","خيميائي الحياة","خيميائي الظلال"],
	"fr":["PYROALCHIMISTE","CRYOALCHIMISTE","ALCHIMISTE DES ORAGES","VITALISTE","ALCHIMISTE DES OMBRES"],
	"bn":["অগ্নি রসায়নবিদ","হিম রসায়নবিদ","ঝড় রসায়নবিদ","জীবন রসায়নবিদ","ছায়া রসায়নবিদ"],
	"pt":["PIROALQUIMISTA","CRIOALQUIMISTA","ALQUIMISTA DA TEMPESTADE","VITALISTA","ALQUIMISTA DAS SOMBRAS"],
	"ur":["آگ کا کیمیاگر","برف کا کیمیاگر","طوفان کا کیمیاگر","حیات کا کیمیاگر","سائے کا کیمیاگر"],
	"id":["ALKEMIS API","ALKEMIS ES","ALKEMIS BADAI","VITALIS","ALKEMIS BAYANGAN"],
	"de":["PYROALCHEMIST","KRYOALCHEMIST","STURMALCHEMIST","VITALIST","SCHATTENALCHEMIST"],
	"ja":["炎の錬金術師","氷の錬金術師","嵐の錬金術師","生命の錬金術師","影の錬金術師"],
	"pcm":["FIRE ALCHEMIST","ICE ALCHEMIST","STORM ALCHEMIST","LIFE ALCHEMIST","SHADOW ALCHEMIST"],
	"arz":["خيميائي النار","خيميائي التلج","خيميائي العاصفة","خيميائي الحياة","خيميائي الضل"]
}
const CLASS_DESCS = {
	"zh":["伤害+10%，燃烧+80%","冰冻时间+80%","法力每秒+3，闪避额外+5","生命+35，治疗+50%，持续恢复","伤害+15%，毒与护盾+50%"],
	"hi":["क्षति +10%, जलन +80%","जमाव समय +80%","माना +3/सेकंड, बचने पर +5","स्वास्थ्य +35, उपचार +50%, पुनर्भरण","क्षति +15%, ज़हर और ढाल +50%"],
	"es":["Daño +10%, quemadura +80%","Congelación dura +80%","Maná +3/s, esquiva +5 extra","Salud +35, cura +50%, regeneración","Daño +15%, veneno y escudo +50%"],
	"ar":["ضرر +10%، حرق +80%","التجميد أطول 80%","مانا +3/ث، المراوغة +5","صحة +35، شفاء +50% وتجدد","ضرر +15%، سم ودرع +50%"],
	"fr":["Dégâts +10 %, brûlure +80 %","Gel prolongé de 80 %","Mana +3/s, esquive +5","Vie +35, soins +50 %, régénération","Dégâts +15 %, poison et bouclier +50 %"],
	"bn":["ক্ষতি +১০%, আগুন +৮০%","বরফ ৮০% বেশি সময়","মানা +৩/সে, এড়ালে +৫","স্বাস্থ্য +৩৫, আরোগ্য +৫০%","ক্ষতি +১৫%, বিষ ও ঢাল +৫০%"],
	"pt":["Dano +10%, queimadura +80%","Gelo dura +80%","Mana +3/s, desvio +5 extra","Vida +35, cura +50%, regeneração","Dano +15%, veneno e escudo +50%"],
	"ur":["نقصان +10%، جلنا +80%","جمنا 80% زیادہ دیر","مانا +3/سیکنڈ، بچاؤ +5","صحت +35، شفا +50%، بحالی","نقصان +15%، زہر اور ڈھال +50%"],
	"id":["Kerusakan +10%, bakar +80%","Beku bertahan +80%","Mana +3/detik, hindar +5","Nyawa +35, sembuh +50%, pulih","Kerusakan +15%, racun dan perisai +50%"],
	"de":["Schaden +10 %, Brand +80 %","Frost dauert 80 % länger","Mana +3/s, Ausweichen +5","Leben +35, Heilung +50 %, Regeneration","Schaden +15 %, Gift und Schild +50 %"],
	"ja":["ダメージ+10%、炎上+80%","凍結時間+80%","マナ毎秒+3、回避でさらに+5","体力+35、回復+50%、自然回復","ダメージ+15%、毒と盾+50%"],
	"pcm":["Damage +10%, fire +80%","Freeze stay 80% longer","Mana +3/sec, dodge add +5","Life +35, heal +50%, recover","Damage +15%, poison and shield +50%"],
	"arz":["ضرر +10%، حرق +80%","التجميد أطول 80%","مانا +3/ث، تفادي +5","صحة +35، علاج +50% وتجدد","ضرر +15%، سم ودرع +50%"]
}
const SLOT_NAMES = {
	"zh":["头部","双手","护符","双脚","戒指","面部","腰带"],
	"hi":["सिर","हाथ","ताबीज","पैर","अंगूठी","चेहरा","कमर"],
	"es":["CABEZA","MANOS","AMULETO","PIES","ANILLO","ROSTRO","CINTURÓN"],
	"ar":["الرأس","اليدان","التميمة","القدمان","الخاتم","الوجه","الحزام"],
	"fr":["TÊTE","MAINS","CHARME","PIEDS","ANNEAU","VISAGE","CEINTURE"],
	"bn":["মাথা","হাত","তাবিজ","পা","আংটি","মুখ","কোমর"],
	"pt":["CABEÇA","MÃOS","AMULETO","PÉS","ANEL","ROSTO","CINTO"],
	"ur":["سر","ہاتھ","تعویذ","پاؤں","انگوٹھی","چہرہ","کمر"],
	"id":["KEPALA","TANGAN","JIMAT","KAKI","CINCIN","WAJAH","SABUK"],
	"de":["KOPF","HÄNDE","TALISMAN","FÜSSE","RING","GESICHT","GÜRTEL"],
	"ja":["頭","手","護符","足","指輪","顔","ベルト"],
	"pcm":["HEAD","HANDS","CHARM","FEET","RING","FACE","BELT"],
	"arz":["الراس","الإيدين","التميمة","الرجلين","الخاتم","الوش","الحزام"]
}
const ITEM_NAMES = {
	"zh":["铜兜帽","月亮王冠","熔炉手套","符文护手","记忆药瓶","生命之心","灰烬靴","寒霜靴","余烬戒指","水银戒指","瘟疫面具","渡鸦面具","铜腰带","风暴腰带","玻璃护符","日蚀护符","守护灯","输血瓶","闪避靴","王冠"],
	"hi":["तांबे का हुड","चंद्र मुकुट","भट्ठी के दस्ताने","रूनी दस्ताने","स्मृति शीशी","जीवित हृदय","राख के जूते","हिम जूते","अंगारा अंगूठी","पारा अंगूठी","महामारी मुखौटा","कौवा मुखौटा","तांबे की पेटी","तूफ़ानी पेटी","काँच ताबीज","ग्रहण ताबीज","रक्षा लालटेन","रक्त शीशी","बचाव जूते","शाही मुकुट"],
	"es":["CAPUCHA DE COBRE","CORONA LUNAR","GUANTES DE HORNO","GUANTELETES RÚNICOS","FRASCO DE MEMORIA","CORAZÓN VIVO","BOTAS DE CENIZA","BOTAS DE ESCARCHA","ANILLO DE BRASA","ANILLO DE MERCURIO","MÁSCARA DE PESTE","MÁSCARA DE CUERVO","CINTURÓN DE COBRE","CINTURÓN DE TORMENTA","AMULETO DE CRISTAL","AMULETO DE ECLIPSE","FAROL GUARDIÁN","FRASCO DE TRANSFUSIÓN","BOTAS DE ESQUIVA","CORONA REAL"],
	"ar":["قلنسوة نحاسية","تاج القمر","قفازات الفرن","قفازات الرون","قارورة الذاكرة","القلب الحي","حذاء الرماد","حذاء الصقيع","خاتم الجمر","خاتم الزئبق","قناع الطاعون","قناع الغراب","حزام نحاسي","حزام العاصفة","تميمة زجاجية","تميمة الكسوف","فانوس الحماية","قارورة نقل الدم","حذاء المراوغة","التاج الملكي"],
	"fr":["CAPUCHE DE CUIVRE","COURONNE LUNAIRE","GANTS DU FOUR","GANTELETS RUNIQUES","FIOLE DE MÉMOIRE","CŒUR VIVANT","BOTTES DE CENDRE","BOTTES DE GIVRE","ANNEAU DE BRAISE","ANNEAU DE MERCURE","MASQUE DE PESTE","MASQUE DE CORBEAU","CEINTURE DE CUIVRE","CEINTURE D'ORAGE","AMULETTE DE VERRE","AMULETTE D'ÉCLIPSE","LANTERNE DE GARDE","FIOLE DE TRANSFUSION","BOTTES D'ESQUIVE","COURONNE ROYALE"],
	"bn":["তামার টুপি","চাঁদের মুকুট","চুল্লির দস্তানা","রুন দস্তানা","স্মৃতির শিশি","জীবন্ত হৃদয়","ছাইয়ের বুট","হিমের বুট","অঙ্গারের আংটি","পারদের আংটি","মহামারির মুখোশ","কাকের মুখোশ","তামার বেল্ট","ঝড়ের বেল্ট","কাচের তাবিজ","গ্রহণের তাবিজ","রক্ষী বাতি","রক্তের শিশি","এড়ানোর বুট","রাজকীয় মুকুট"],
	"pt":["CAPUZ DE COBRE","COROA LUNAR","LUVAS DA FORNALHA","MANOPLAS RÚNICAS","FRASCO DE MEMÓRIA","CORAÇÃO VIVO","BOTAS DE CINZA","BOTAS DE GELO","ANEL DE BRASA","ANEL DE MERCÚRIO","MÁSCARA DA PESTE","MÁSCARA DO CORVO","CINTO DE COBRE","CINTO DA TEMPESTADE","AMULETO DE VIDRO","AMULETO DO ECLIPSE","LANTERNA DE GUARDA","FRASCO DE TRANSFUSÃO","BOTAS DE ESQUIVA","COROA REAL"],
	"ur":["تانبے کا ہڈ","چاند کا تاج","بھٹی کے دستانے","رونی دستانے","یاد کی شیشی","زندہ دل","راکھ کے جوتے","برف کے جوتے","انگارے کی انگوٹھی","پارے کی انگوٹھی","وبا کا نقاب","کوّے کا نقاب","تانبے کی پیٹی","طوفانی پیٹی","شیشے کا تعویذ","گرہن کا تعویذ","حفاظتی لالٹین","خون کی شیشی","بچاؤ جوتے","شاہی تاج"],
	"id":["TUDUNG TEMBAGA","MAHKOTA BULAN","SARUNG TUNGKU","SARUNG RUNE","BOTOL INGATAN","JANTUNG HIDUP","SEPATU ABU","SEPATU ES","CINCIN BARA","CINCIN RAKSA","TOPENG WABAH","TOPENG GAGAK","SABUK TEMBAGA","SABUK BADAI","JIMAT KACA","JIMAT GERHANA","LENTERA PENJAGA","BOTOL TRANSFUSI","SEPATU HINDAR","MAHKOTA KERAJAAN"],
	"de":["KUPFERKAPUZE","MONDKRONE","OFENHANDSCHUHE","RUNENHANDSCHUHE","ERINNERUNGSFLÄSCHCHEN","LEBENDIGES HERZ","ASCHESTIEFEL","FROSTSTIEFEL","GLUTRING","QUECKSILBERRING","PESTMASKE","RABENMASKE","KUPFERGÜRTEL","STURMGÜRTEL","GLASAMULETT","FINSTERNISAMULETT","WÄCHTERLATERNE","TRANSFUSIONSFLÄSCHCHEN","AUSWEICHSTIEFEL","KÖNIGSKRONE"],
	"ja":["銅のフード","月の冠","炉の手袋","ルーンの籠手","記憶の瓶","生きた心臓","灰のブーツ","霜のブーツ","残り火の指輪","水銀の指輪","疫病の仮面","大鴉の仮面","銅のベルト","嵐のベルト","ガラスの護符","日食の護符","守護のランタン","輸血の瓶","回避のブーツ","王家の冠"],
	"pcm":["COPPER HOOD","MOON CROWN","FURNACE GLOVES","RUNE GLOVES","MEMORY BOTTLE","LIVING HEART","ASH BOOTS","FROST BOOTS","EMBER RING","MERCURY RING","PLAGUE MASK","RAVEN MASK","COPPER BELT","STORM BELT","GLASS CHARM","ECLIPSE CHARM","WARD LANTERN","BLOOD BOTTLE","DODGE BOOTS","KING CROWN"],
	"arz":["كاب نحاس","تاج القمر","جوانتي الفرن","جوانتي الرون","إزازة الذكريات","القلب الحي","جزمة الرماد","جزمة التلج","خاتم الجمر","خاتم الزئبق","قناع الوباء","قناع الغراب","حزام نحاس","حزام العاصفة","تميمة إزاز","تميمة الكسوف","فانوس الحراسة","إزازة نقل الدم","جزمة التفادي","التاج الملكي"]
}
const STAT_NAMES = {
	"zh":["生命","法力","伤害","回魔","燃烧","冰冻"],
	"hi":["स्वास्थ्य","माना","क्षति","पुनर्भरण","जलन","जमाव"],
	"es":["Salud","Maná","Daño","Recarga","Fuego","Hielo"],
	"ar":["صحة","مانا","ضرر","تجدد","حرق","تجميد"],
	"fr":["Santé","Mana","Dégâts","Recharge","Brûlure","Gel"],
	"bn":["স্বাস্থ্য","মানা","ক্ষতি","পুনরুদ্ধার","আগুন","বরফ"],
	"pt":["Vida","Mana","Dano","Recarga","Queimar","Gelo"],
	"ur":["صحت","مانا","نقصان","بحالی","جلنا","جمنا"],
	"id":["Nyawa","Mana","Dampak","Pulih","Bakar","Beku"],
	"de":["Leben","Mana","Schaden","Erholung","Brand","Frost"],
	"ja":["体力","マナ","ダメージ","回復","炎上","凍結"],
	"pcm":["Life","Mana","Damage","Recovery","Fire","Freeze"],
	"arz":["صحة","مانا","ضرر","تجدد","حرق","تلج"]
}

static func get_text(language: String, key: String) -> String:
	var own: Dictionary = TEXT.get(language, {})
	if own.has(key): return own[key]
	var new_index := NEW_UI_KEYS.find(key)
	if new_index >= 0 and NEW_UI.has(language): return NEW_UI[language][new_index]
	var level_index := ["level_up", "level_bonus", "level_effect"].find(key)
	if level_index >= 0 and LEVEL_TEXT.has(language): return LEVEL_TEXT[language][level_index]
	var expansion_index := ["enemy_down", "next_foe", "shop_hint", "max_level"].find(key)
	if expansion_index >= 0 and EXPANSION_UI.has(language): return EXPANSION_UI[language][expansion_index]
	if key.begins_with("class_"):
		var part := key.trim_prefix("class_")
		var is_desc := part.ends_with("_desc")
		if is_desc: part = part.trim_suffix("_desc")
		var index := CLASS_KEYS.find(part)
		var values: Array = (CLASS_DESCS if is_desc else CLASS_NAMES).get(language, [])
		if index >= 0 and index < values.size(): return values[index]
	if key.begins_with("slot_"):
		var index := SLOT_KEYS.find(key.trim_prefix("slot_"))
		if index >= 0: return SLOT_NAMES.get(language, [])[index]
	if key.begins_with("item_") and not key.ends_with("_desc"):
		var index := ITEM_KEYS.find(key.trim_prefix("item_"))
		var names: Array = ITEM_NAMES.get(language, [])
		if index >= 0 and index < names.size(): return names[index]
	if key.begins_with("item_") and key.ends_with("_desc"):
		var item_id := key.trim_prefix("item_").trim_suffix("_desc")
		var index := ITEM_KEYS.find(item_id)
		if index >= 0:
			var item: Dictionary = Profile.ITEMS[index]
			var parts: Array = []
			var keys := ["hp", "mana", "damage", "regen", "burn", "slow"]
			for j in range(keys.size()):
				var value := float(item.get(keys[j], 0.0))
				if value <= 0: continue
				var amount := ("+%d%%" % int(round(value * 100.0))) if keys[j] in ["damage", "burn", "slow"] else ("+%s/s" % str(value) if keys[j] == "regen" else "+%d" % int(value))
				parts.append(STAT_NAMES.get(language, [])[j] + " " + amount)
			return ", ".join(parts)
	return ""
