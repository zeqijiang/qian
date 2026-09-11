# 技术设计

## 引擎与语言
- Godot 4.4.1
- GDScript
- 渲染：gl_compatibility（兼容性更好）

## 架构原则
- 模块化：禁止把全部逻辑写进 Player.gd
- 数据驱动：角色/技能数值走 Resource
- 状态机驱动一切行为切换
- Hitbox / Hurtbox 分离，禁止用角色整体碰撞框直接判攻击

## 物理层
| Layer | 名称 | 用途 |
|------|------|------|
| 1 | world | 地面/墙 |
| 2 | player | 玩家身体 |
| 3 | enemy | 敌人身体 |
| 4 | hitbox | 攻击判定 |
| 5 | hurtbox | 受击判定 |

## 核心节点
```
Character (CharacterBody2D)
├── CollisionShape2D
├── Hurtbox (Area2D)
├── Hitbox (Area2D)
├── VisualRoot
└── StateMachine
```
CombatController / InputController / AIController 在运行时挂载。

## 伤害公式
```
FinalDamage = BaseDamage × SkillMultiplier × DefenseModifier × StateModifier
```
- SkillMultiplier 含角色 attack 与复苏强化系数
- DefenseModifier = 1 / defense

## 状态机
基类 `State`：enter / exit / process / physics_process / can_cancel_to  
强制切换 `force_change`（受击、死亡）；普通切换 `change_state` 遵守取消表。

## 能量系统
- **灵异值 Spirit**：释放技能资源，攻击/受击/缓慢回复
- **复苏值 Revival**：危险资源，越用越接近厉鬼复苏；达到阈值后强化攻击

## 调试快捷键
| 键 | 功能 |
|----|------|
| F1 | Hitbox 显示 |
| F2 | Hurtbox 显示 |
| F3 | 角色状态 |
| F4 | FPS |
| F5 | 重置战斗 |
| F6 | 无敌 |
| F7 | 无限灵异值 |

## 玩家默认键位
| 键 | 功能 |
|----|------|
| A/D 或 ←/→ | 移动 |
| W/Space/↑ | 跳跃 |
| Shift 或 L | 冲刺 |
| J | 轻攻击 |
| K | 重攻击 |
| ← (Left) | 格挡 |
| U/I/O/P | 技能占位 |
| F5 | 重开 |

## 目录
见仓库根目录 `scenes/ scripts/ data/ characters/ assets/ docs/`。
