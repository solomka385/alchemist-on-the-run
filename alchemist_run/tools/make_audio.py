"""Generate original, lightweight procedural audio for the prototype."""
from math import pi, sin, exp, tanh
from pathlib import Path
import random
import wave

RATE = 22050
OUT = Path(__file__).resolve().parents[1] / "assets" / "audio"
OUT.mkdir(parents=True, exist_ok=True)
random.seed(7)


def write(name, samples):
    pcm = bytearray()
    for sample in samples:
        value = int(max(-1.0, min(1.0, sample)) * 32767)
        pcm += value.to_bytes(2, "little", signed=True)
    with wave.open(str(OUT / name), "wb") as sound:
        sound.setnchannels(1)
        sound.setsampwidth(2)
        sound.setframerate(RATE)
        sound.writeframes(pcm)


def tone(name, seconds, f0, f1, noise=0.0, metallic=False):
    count = int(seconds * RATE)
    samples = []
    phase = 0.0
    for i in range(count):
        t = i / RATE
        progress = t / seconds
        freq = f0 + (f1 - f0) * progress
        phase += 2 * pi * freq / RATE
        env = sin(pi * progress) ** 0.75 * exp(-1.7 * progress)
        overtone = 0.20 * sin(phase * (3.12 if metallic else 2.0))
        hiss = (random.random() * 2 - 1) * noise
        samples.append((sin(phase) + overtone + hiss) * env * 0.38)
    write(name, samples)


def ambient():
    seconds = 12
    notes = [55.0, 65.4, 73.4, 65.4]
    samples = []
    for i in range(seconds * RATE):
        t = i / RATE
        fade = min(1.0, t / 1.0, (seconds - t) / 1.0)
        low = 0.15 * sin(2 * pi * 55 * t) + 0.075 * sin(2 * pi * 110.2 * t)
        note = notes[int(t / 3)]
        melody = 0.06 * sin(2 * pi * note * t) * (0.5 - 0.5 * sin(2 * pi * t / 6))
        thrum = 0.025 * sin(2 * pi * 27.5 * t) * (0.5 + 0.5 * sin(2 * pi * t / 3))
        texture = 0.01 * (random.random() * 2 - 1)
        samples.append(tanh((low + melody + thrum + texture) * fade) * 0.5)
    write("ambient.wav", samples)


ambient()

def location_music(name, root, pattern, tempo, texture):
    """Short seamless, deliberately distinct procedural location loops."""
    seconds = 8
    samples = []
    for i in range(seconds * RATE):
        t = i / RATE
        beat = t * tempo / 60.0
        step = int(beat * 2) % len(pattern)
        note = root * (2 ** (pattern[step] / 12.0))
        gate = exp(-4.0 * (beat * 2 % 1.0))
        drone = 0.10 * sin(2 * pi * root / 2 * t) + 0.045 * sin(2 * pi * root * t)
        voice = gate * (0.11 * sin(2 * pi * note * t) + 0.035 * sin(2 * pi * note * 2.01 * t))
        pulse = 0.025 * sin(2 * pi * 35 * t) * exp(-12.0 * (beat % 1.0))
        noise = texture * (random.random() * 2 - 1) * (0.25 + 0.75 * gate)
        edge = min(1.0, t / 0.08, (seconds - t) / 0.08)
        samples.append(tanh(drone + voice + pulse + noise) * 0.62 * edge)
    write(name, samples)


location_music("menu.wav", 55.0, [0, 7, 3, 10, 0, 7, 5, 3], 60, 0.005)
location_music("location_0.wav", 65.4, [0, 3, 7, 10, 0, 7, 3, -2], 90, 0.009)
location_music("location_1.wav", 73.4, [0, 5, 7, 12, 7, 5, 3, 5], 75, 0.016)
location_music("location_2.wav", 82.4, [0, 7, 6, 12, 0, 6, 7, 3], 110, 0.006)
location_music("location_3.wav", 55.0, [0, 2, 6, 9, 0, 9, 6, 2], 68, 0.013)
location_music("location_4.wav", 61.7, [0, 1, 6, 8, 12, 8, 6, 1], 120, 0.022)
location_music("location_5.wav", 69.3, [0, 5, 10, 7, 3, 7, 10, 5], 84, 0.012)
location_music("location_6.wav", 77.8, [0, 4, 11, 7, 4, 2, 7, 11], 64, 0.004)
location_music("location_7.wav", 58.3, [0, 3, 8, 12, 8, 3, 5, 1], 72, 0.009)
location_music("location_8.wav", 92.5, [0, 6, 9, 12, 9, 6, 3, 1], 104, 0.017)
location_music("location_9.wav", 103.8, [0, 3, 7, 12, 7, 3, 10, 5], 126, 0.020)
location_music("location_10.wav", 69.3, [0, 5, 9, 12, 9, 5, 2, 7], 80, 0.008)
location_music("location_11.wav", 58.3, [0, 2, 7, 10, 7, 2, 5, 3], 66, 0.013)
location_music("location_12.wav", 87.3, [0, 4, 7, 11, 7, 4, 2, 9], 92, 0.007)

for boss, root in [(2, 82), (5, 117), (9, 53), (10, 69), (11, 98), (12, 139), (13, 61), (14, 47), (15, 109), (16, 74), (17, 146)]:
    tone("boss_%d_intro.wav" % boss, 0.8, root, root * 2.12, 0.15, boss == 5)
    tone("boss_%d_attack.wav" % boss, 0.48, root * 2.5, root * 0.72, 0.32, boss == 5)
    tone("boss_%d_death.wav" % boss, 1.15, root * 2, root * 0.35, 0.20, boss == 5)

tone("mix.wav", 0.18, 320, 890, 0.15, True)
tone("cast.wav", 0.31, 540, 180, 0.38, True)
tone("hit.wav", 0.25, 190, 48, 0.55)
tone("hurt.wav", 0.36, 115, 42, 0.65)
tone("dodge.wav", 0.21, 260, 620, 0.30)
tone("reward.wav", 0.55, 390, 790, 0.04)
