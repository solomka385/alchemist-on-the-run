"""Create compact nearest-neighbor game textures from the generated source art."""
from pathlib import Path
from PIL import Image

PROJECT = Path(__file__).resolve().parents[1]
SOURCES = PROJECT / "source_art"
ASSETS = PROJECT / "assets"
SIZES = {
    "corridor": (240, 427),
    "greenhouse": (240, 427),
    "glassworks": (240, 427),
    "archives": (240, 427),
    "citadel": (240, 427),
    "furnace": (196, 180),
    "ash_courier": (196, 180),
    "mirror_hound": (196, 180),
    "plague_scribe": (196, 180),
    "rust_choir": (196, 180),
    "clock_wisp": (196, 180),
    "shard_collector": (196, 180),
    "boss_greenhouse": (196, 180),
    "boss_glass": (196, 180),
    "boss_faceless": (196, 180),
    "hands": (384, 256),
}
for stem, target in SIZES.items():
    with Image.open(SOURCES / f"{stem}.png") as source:
        source.thumbnail(target, Image.Resampling.LANCZOS)
        if stem in ("corridor", "greenhouse", "glassworks", "archives", "citadel"):
            # The original 2:3 frame fills the portrait game view without gaps.
            source = Image.open(SOURCES / f"{stem}.png").convert("RGBA")
            width = int(source.height * target[0] / target[1])
            left = (source.width - width) // 2
            source = source.crop((left, 0, left + width, source.height))
            source = source.resize(target, Image.Resampling.LANCZOS)
            canvas = source
        else:
            canvas = source.resize(target, Image.Resampling.LANCZOS).convert("RGBA")
        canvas.save(ASSETS / f"{stem}_game.png", optimize=True)

for source_path in sorted(SOURCES.glob("avatar_*.png")):
    with Image.open(source_path) as source:
        source = source.convert("RGBA")
        square = min(source.size)
        left = (source.width - square) // 2
        top = (source.height - square) // 2
        avatar = source.crop((left, top, left + square, top + square))
        avatar.resize((128, 128), Image.Resampling.LANCZOS).save(
            ASSETS / source_path.name, optimize=True
        )

item_ids = [
    "hood", "crown", "gloves", "gauntlets", "vial", "heart", "ash_boots", "frost_boots",
    "ember_ring", "mercury_ring", "plague_mask", "raven_mask", "copper_belt", "storm_belt",
    "glass_amulet", "eclipse_amulet",
]
with Image.open(SOURCES / "shop_icons_atlas.png") as atlas:
    atlas = atlas.convert("RGBA")
    cell_w, cell_h = atlas.width // 4, atlas.height // 4
    for index, item_id in enumerate(item_ids):
        col, row = index % 4, index // 4
        icon = atlas.crop((col * cell_w, row * cell_h, (col + 1) * cell_w, (row + 1) * cell_h))
        icon.resize((80, 80), Image.Resampling.LANCZOS).save(
            ASSETS / f"item_{item_id}.png", optimize=True
        )
