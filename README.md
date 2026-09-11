# 神秘复苏：灵异格斗

2D 横版竞技格斗原型（Godot 4.4.1 / GDScript）。

## 快速开始

1. 安装 [Godot 4.4.1](https://godotengine.org/download)（或使用本机已下载的编辑器）
2. 用 Godot 打开本目录的 `project.godot`
3. 按 F5 运行（主场景为 `scenes/battle/battle.tscn`，训练模式）

也可双击 `run_game.bat`（若 Godot 路径一致）。

## 当前可玩内容（Phase 0 原型）

- 杨间（蓝方，玩家） vs 占位敌人（红方，AI）
- 移动 / 跳跃 / 冲刺 / 格挡
- 轻攻击、重攻击、空中攻击
- Hitbox / Hurtbox 判定、伤害、击退、硬直、倒地、起身、死亡
- Combo 统计
- 灵异值 / 复苏值 UI
- 训练场自动重置

## 默认键位

| 键 | 功能 |
|----|------|
| A/D 或 ←/→ | 左右移动 |
| W / Space / ↑ | 跳跃 |
| Shift 或 L | 冲刺 |
| J | 轻攻击 |
| K | 重攻击 |
| ←（Left 键） | 格挡 |
| U / I / O / P | 技能位（待接入） |
| F1 | 显示 Hitbox |
| F2 | 显示 Hurtbox |
| F3 | 显示角色状态 |
| F4 | 显示 FPS |
| F5 | 重置战斗 |
| F6 | 无敌开关 |
| F7 | 无限灵异值 |

## 测试

```powershell
& "C:\Users\admin\tools\Godot_v4.4.1-stable_win64_console.exe" --headless --path . --script res://tests/smoke_test.gd
```

## 文档

- `docs/PROJECT_LOG.md` — 开发日志
- `docs/GAME_DESIGN.md` — 玩法总览
- `docs/TECHNICAL_DESIGN.md` — 技术架构
- `docs/CHARACTER_DESIGN.md` — 角色设计
- `docs/CHANGELOG.md` — 版本记录

## 版权说明

本项目为个人学习 / 私人 Demo。若公开发布或商业化，需重新审查《神秘复苏》相关 IP 与素材授权，或转换为原创灵异世界观。
