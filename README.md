# 神秘复苏：灵异格斗

2D 横版竞技格斗原型（**Godot 4.4.1** / GDScript）。

> 个人学习 / 私人 Demo。世界观与角色名致敬《神秘复苏》；**请勿默认拥有商业使用权**。详见 [LICENSE](LICENSE) 与 [assets/THIRD_PARTY.md](assets/THIRD_PARTY.md)。

## 快速开始

1. 安装 [Godot 4.4.1+](https://godotengine.org/download)
2. 用 Godot 打开本仓库根目录的 `project.godot`
3. 按 **F5** 运行 → 主菜单 → 训练 / VS → 选人 → 开战

Windows 也可运行 `run_game.bat`（需本机 Godot 路径一致，可自行改脚本）。

## 可选角色

| 角色 | 定位 | 代表技能 |
|------|------|----------|
| 杨间 | 综合 · 规则 | 鬼眼定位 / 鬼域红雾 / 棺材钉 / 鬼影 |
| 叶真 | 近战 · 霸体 | 鬼拳镇压 / 铁壁 / 霸体重击 |
| 张羡光 | 机动 · 分身 | 影遁 / 影子分身 / 鬼教室 |
| 李乐平 | 暗杀 · 标记 | 遗忘 / 找人鬼 / 鬼烟 |
| **船长**（默认反派） | 召唤 · 冲刷 | 登船扣押 / 厉鬼潮 / 灵异海水 / 方舟降临 |

## 默认键位

| 键 | 功能 |
|----|------|
| A/D 或 ←/→ | 移动 / 选人 |
| W / Space / ↑ | 跳跃 |
| Shift | 冲刺 |
| J / K | 轻 / 重攻击 |
| ←（Left） | 格挡 |
| U / I / O / H | 技能 1–4 |
| P | 奥义（满 100 灵异） |
| Enter / Esc | 确认 / 返回 |
| Tab | 训练⇄VS 或回菜单 |
| F5–F9 | 重开 / 无敌 / 无限灵异 / 木桩 / 复位 |

## 系统概览

- 状态机 + Hitbox/Hurtbox 判定、连段、顿帧、镜头震动、斩击特效
- 灵异值 / 复苏值、技能冷却 HUD、伤害飘字
- 训练场与 VS AI（99 秒，时间到按剩余 HP）
- 数据驱动技能包（`scripts/skill/*_kit.gd`）

## 目录

```
assets/     精灵与音效
data/       角色数据资源
docs/       设计与开发日志
scenes/     场景
scripts/    GDScript
tests/      无头冒烟测试
tools/      素材处理脚本
```

## 测试

```powershell
godot --headless --path . --script res://tests/smoke_test.gd
```

## 许可

- **代码**：MIT
- **打击音效**：Kenney CC0
- **角色立绘**：用户提供，请自行确认再公开分发
