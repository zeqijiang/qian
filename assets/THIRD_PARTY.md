# Third-party assets

## Kenney Impact Sounds (CC0)
- Source: https://kenney.nl/assets/impact-sounds
- License: Creative Commons CC0 (see assets/audio/KENNEY_LICENSE.txt)
- Used for: hit / skill impact SFX

## Character sprites (user-provided)
- `assets/sprites/yangjian.png` — 黑发 Q 版杨间
- `assets/sprites/ye_zhen.png` — 白发 Q 版叶真
- `assets/sprites/zhang_xianguang.png` — 张羡光
- `assets/sprites/li_leping.png` — 李乐平
- `assets/sprites/captain.png` — 船长
- Processed: 去白底、缩放到约 180–200px 高

## Stage background (user-provided)
- `assets/stages/port_battle.png` — 码头灵异对战场景（用户提供 / AI 生成图）
- Resized to 1920×1080 for in-game backdrop
- 若公开/商用，请自行确认授权与水印要求

## Generated / code-drawn FX
Slash arcs, sparks, afterimages, banners, domain overlay are drawn in-engine
(`scripts/core/combat_fx.gd`). Procedural idle bob / attack punch / walk lean
are in `scripts/utility/fighter_sprite.gd`.

## Note on character animations
Full anime combo sprite packs (e.g. Bleach vs Naruto fan games) are usually
copyrighted. This prototype uses the user's still art + code-driven motion.
If you later add open-source sprite sheets, keep license files here.
