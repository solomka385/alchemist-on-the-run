# Визуальное направление

Вертикальная композиция от первого лица. Грязный ретро 3D с видимыми крупными пикселями, ржавой медью, камнем, копотью, выцветшим мхом и редкими кислотно зелёными источниками света. Интерфейс собирается из почти чёрных прямоугольников с тонкими латунными рамками. Цвета ингредиентов контрастны и дублируются римскими метками I–XII. Боссы помещены выше рук и отделены от фона тёмным силуэтом. Пять школ различаются цветом перчаток и знаком на манжете. Ключевые действия остаются в крупных сенсорных областях.

Собственные ассеты, 2 октября 2026:

| Файл | Роль | Источник |
| --- | --- | --- |
| `corridor.png` и ещё четыре фона | дороги и локации, ракурс от первого лица | OpenAI ImageGen |
| `furnace.png` и ещё девять силуэтов | противники и боссы, прозрачный фон | OpenAI ImageGen |
| `hands.png` | две руки с прозрачными колбами | OpenAI ImageGen |
| `avatar_*.png` | десять оригинальных портретов алхимиков, прозрачный фон | OpenAI ImageGen, 3 октября 2026 |
| `shop_icons_atlas.png` | 16 отдельных пиксельных предметов 4×4, прозрачный фон | OpenAI ImageGen, 3 октября 2026 |
| `expansion_bosses_atlas.png` | четыре новых босса 2×2, прозрачный фон | OpenAI ImageGen, 3 октября 2026; разделены скриптом `tools/split_expansion_art.py` |
| `expansion_places_atlas.png` | четыре новых дороги 2×2 | OpenAI ImageGen, 3 октября 2026; разделены скриптом `tools/split_expansion_art.py` |
| `second_items_atlas.png` | сторожевой фонарь, колба переливания, сапоги тени, королевский венец | OpenAI ImageGen, 3 октября 2026; разделены скриптом `tools/split_expansion_art.py` |
| `second_bosses_atlas.png` | соляной великан, змей акведука, звёздный призрак, кузнечная вдова | OpenAI ImageGen, 3 октября 2026; разделены скриптом `tools/split_expansion_art.py` |
| `second_places_atlas.png` | кузнечный мост, лазарет, вороний монастырь, призменное хранилище | OpenAI ImageGen, 3 октября 2026; разделены скриптом `tools/split_expansion_art.py` |

Оригинальные промпты:

- Коридор: «dark alchemy mobile runner, original grimy retro 1990s low-poly dungeon, pixelated textures and dithering, oxidized copper pipes, amber lanterns, green alchemical mist, centered perspective, empty cobblestone path, no characters, no text».
- Страж: «transparent full-body front-facing alchemical furnace golem, battered rust copper armor, glowing furnace chest, strong readable silhouette, retro low-poly 3D with crunchy pixel texture, no text or background».
- Руки: «transparent first-person pair of gloved alchemist hands holding empty clear round glass flasks, broad gap between hands, retro low-poly 3D with crunchy pixel texture, no text or scenery».
- Портреты: «square transparent bust portrait of an original dark fantasy alchemist character, distinctive hood or mask and small alchemical accessories, warm copper and near-black palette with one character-specific accent color, crunchy 1990s pixel-textured low-poly 3D game art, centered head and shoulders, no text, no background». Десять вариантов отличаются профессией и силуэтом: ученик, огонь, лёд, гроза, травник, стекло, ворон, чума, часы, затмение.
- Предметы: «single production-ready transparent UI sprite sheet, exactly 16 icons in 4×4 rigid grid, copper hood, moon crown, furnace gloves, rune gauntlets, memory vial, living heart, ash boots, frost boots, ember ring, mercury ring, plague mask, raven mask, copper belt, storm belt, glass amulet, eclipse amulet; chunky pixel-textured low-poly 1990s 3D, oxidized copper and amber edge light, no text or borders». Атлас был визуально проверен и разделён на 16 иконок.
- Новые боссы: «four full-body boss monsters in a 2×2 sheet: brass plague bell golem, fungal queen with roots, molten clock knight, ash moth oracle; transparent background, gritty pixelated pre-rendered 3D, copper and soot, readable silhouettes, no labels».
- Новые локации: «four central-perspective runner paths in a 2×2 sheet: flooded copper aqueduct, bone observatory, underground salt cathedral, shattered clock tower; gritty pixelated pre-rendered 3D, no characters or text».

Перед релизом ассеты нужно проверить на реальных iPhone, включая прозрачные края, читаемость силуэтов, объём памяти и композицию за элементами интерфейса.

Оригиналы лежат в `source_art/`, исключённой из импорта Godot. Для игры `tools/normalize_art.py` и `tools/split_expansion_art.py` создают компактные файлы `assets/*_game.png` (240×427, 196×180 и 384×256), `assets/avatar_*.png` (128×128) и `assets/item_*.png` (80×80). Рендер Godot использует фильтрацию `Nearest`, чтобы сохранить крупные пиксели. Новые атласы визуально проверены после разделения; текст и рамки интерфейса отрисовывает Godot.
