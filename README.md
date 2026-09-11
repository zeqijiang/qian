# 神秘复苏：灵异格斗

2D 横版竞技格斗原型（Godot 4.4.1 / GDScript）。

## 快速开始

1. 用 Godot 4.4.1 打开本目录的 `project.godot`
2. F5 → **主菜单** → 训练 / VS → 选人 → 开战

也可双击 `run_game.bat`。

## 可选角色
- **杨间**：鬼手 / 鬼影 / 鬼域 / 鬼眼压制 / 奥义
- **叶真**：铁冲 / 崩拳 / 铁壁无敌 / 霸体重击 / 奥义绝对反击
- 占位敌人：AI 测试用

## 当前可玩内容

- 主菜单 + 角色选择
- 训练场 / VS AI（99s）
- 移动 / 跳 / 冲刺 / 格挡 / 轻重空攻 / 灵异技能
- 判定、连段、灵异值 / 复苏值、伤害飘字
- F8 木桩、F9 复位、F6 无敌、F7 无限灵异

## 默认键位

| 键 | 功能 |
|----|------|
| A/D 或 ←/→ | 移动 / 选人 |
| W / Space / ↑ | 跳跃 |
| Shift 或 L | 冲刺 |
| J / K | 轻 / 重攻击 |
| ←（Left） | 格挡 |
| U / I / O / H / P | 技能 1–4 / 奥义 |
| Enter | 确认 |
| Esc | 返回菜单 |
| Tab | 训练⇄VS 或回菜单 |
| F1–F7 | 调试 |
| F8 / F9 | 木桩 / 复位 |

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
