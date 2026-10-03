"""Normalize the two original expansion atlases for the 480x854 Godot canvas."""
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "source_art"
OUT = ROOT / "assets"

def cells(path):
    with Image.open(SRC / path) as atlas:
        atlas = atlas.convert("RGBA")
        w, h = atlas.width // 2, atlas.height // 2
        for row in range(2):
            for col in range(2):
                yield atlas.crop((col * w, row * h, (col + 1) * w, (row + 1) * h))

for name, cell in zip(["bell_king", "fungal_queen", "clock_knight", "ash_oracle"], cells("expansion_bosses_atlas.png")):
    cell.resize((196, 180), Image.Resampling.LANCZOS).save(OUT / f"{name}_game.png", optimize=True)

for name, cell in zip(["aqueduct", "observatory", "salt_cathedral", "clock_tower"], cells("expansion_places_atlas.png")):
    target_ratio = 240 / 427
    crop_width = int(cell.height * target_ratio)
    left = (cell.width - crop_width) // 2
    cell.crop((left, 0, left + crop_width, cell.height)).resize((240, 427), Image.Resampling.LANCZOS).save(OUT / f"{name}_game.png", optimize=True)

for name, cell in zip(["salt_giant", "aqueduct_serpent", "star_revenant", "forge_widow"], cells("second_bosses_atlas.png")):
    cell.resize((196, 180), Image.Resampling.LANCZOS).save(OUT / f"{name}_game.png", optimize=True)

for name, cell in zip(["forge_bridge", "infirmary", "raven_cloister", "prism_vault"], cells("second_places_atlas.png")):
    crop_width = int(cell.height * 240 / 427)
    left = (cell.width - crop_width) // 2
    cell.crop((left, 0, left + crop_width, cell.height)).resize((240, 427), Image.Resampling.LANCZOS).save(OUT / f"{name}_game.png", optimize=True)

for name, cell in zip(["ward_lantern", "transfusion", "dodge_boots", "royal_crown"], cells("second_items_atlas.png")):
    cell.resize((80, 80), Image.Resampling.LANCZOS).save(OUT / f"item_{name}.png", optimize=True)
