from PIL import Image
from pathlib import Path

src = Path(r"C:\Users\admin\Doubao\chats\2026-09-11\new-chat\q版海盗船长角色.png")
dst = Path(r"C:\Users\admin\XiaomiMiMoProjects\spirit-revival-fighting\assets\sprites\captain.png")
dst.parent.mkdir(parents=True, exist_ok=True)

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
target_h = 200  # boss slightly larger
ratio = target_h / im.height
im = im.resize((max(1, int(im.width * ratio)), target_h), Image.NEAREST)
im.save(dst)
print("saved", dst, im.size)
