from PIL import Image
from pathlib import Path

src_dir = Path(r"C:\Users\admin\Doubao\chats\2026-09-11\new-chat")
dst_dir = Path(r"C:\Users\admin\XiaomiMiMoProjects\spirit-revival-fighting\assets\sprites")
dst_dir.mkdir(parents=True, exist_ok=True)

jobs = [
    ("q版黑发角色.png", "yangjian.png"),
    ("q版白发角色.png", "ye_zhen.png"),
]

for src_name, dst_name in jobs:
    src = src_dir / src_name
    im = Image.open(src).convert("RGBA")
    px = im.load()
    w, h = im.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if r > 245 and g > 245 and b > 245:
                px[x, y] = (r, g, b, 0)
            elif r > 235 and g > 235 and b > 235 and abs(r - g) < 8 and abs(g - b) < 8:
                px[x, y] = (r, g, b, 40)
    bbox = im.getbbox()
    if bbox:
        im = im.crop(bbox)
    target_h = 180
    ratio = target_h / im.height
    target_w = max(1, int(im.width * ratio))
    im = im.resize((target_w, target_h), Image.NEAREST)
    out = dst_dir / dst_name
    im.save(out)
    print(f"saved {out} size={im.size}")
