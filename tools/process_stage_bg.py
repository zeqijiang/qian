from PIL import Image
from pathlib import Path

src = Path(r"C:\Users\admin\Desktop\神秘复苏中国战时码头对战场景描写原文.png")
dst = Path(r"C:\Users\admin\XiaomiMiMoProjects\spirit-revival-fighting\assets\stages\port_battle.png")
dst.parent.mkdir(parents=True, exist_ok=True)

im = Image.open(src).convert("RGB")
print("src size", im.size)
# Game viewport is 1280x720; export 1920x1080 for slight zoom headroom
target_w, target_h = 1920, 1080
# cover-fit crop to 16:9 then resize
sw, sh = im.size
src_ratio = sw / sh
dst_ratio = target_w / target_h
if src_ratio > dst_ratio:
    # too wide, crop sides
    new_w = int(sh * dst_ratio)
    left = (sw - new_w) // 2
    im = im.crop((left, 0, left + new_w, sh))
else:
    new_h = int(sw / dst_ratio)
    top = (sh - new_h) // 2
    im = im.crop((0, top, sw, top + new_h))
im = im.resize((target_w, target_h), Image.LANCZOS)
im.save(dst, "PNG", optimize=True)
print("saved", dst, im.size, dst.stat().st_size)
