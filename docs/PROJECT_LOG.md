# 神秘复苏：灵异格斗 — 项目日志

## [2026-09-11]

### 本轮目标
- Phase 0：初始化 Godot 4.x 项目与可运行战斗原型骨架
- 建立目录、Git、核心战斗模块、训练场、杨间/占位敌人

### 已完成
- 下载并安装 Godot 4.4.1 stable（`C:\Users\admin\tools\Godot_v4.4.1-stable_win64.exe`）
- 创建项目根目录：`C:\Users\admin\XiaomiMiMoProjects\spirit-revival-fighting`
- 完整目录结构（scenes/scripts/data/characters/assets/tests/docs）
- Git 仓库初始化（main 分支）
- project.godot：输入映射、物理层、Autoload（Game / Debug）
- 角色模块：CharacterBody2D + StateMachine + Input/AI
- 状态机：Idle / Walk / Jump / Fall / Dash / Block / AttackLight / AttackHeavy / AttackAir / Skill / Hit / AirHit / Knockdown / GetUp / Dead
- 战斗：Hitbox / Hurtbox / DamageInfo / CombatController / ComboManager / EnergyManager（灵异值 + 复苏值）
- AIController（Easy/Normal/Hard 基础行为）
- PlaceholderVisual 占位美术
- 场景：main / battle / character / training
- UI：BattleHUD（HP/灵异/复苏/Combo/Timer/调试）
- 数据：yangjian_stats.tres / placeholder_enemy_stats.tres
- 训练场调试：F1 Hitbox、F2 Hurtbox、F3 状态、F4 FPS、F5 重置、F6 无敌、F7 无限灵异

### 修改文件
- 新建全部项目文件（见上）

### 新增功能
- 可启动战斗原型：移动、跳跃、冲刺、格挡、轻/重/空攻击、受击、击退、硬直、倒地、起身、死亡、训练重置
- 灵异值消耗/回复、复苏值积累与阈值
- Combo 统计

### 修复 Bug
- 修正 Hitbox 碰撞体 disabled 导致无法命中
- 修正攻击 Hitbox 朝向随 facing 翻转
- 修正 InputController/AI 的 process_priority，保证先读输入再切状态
- 移除 character.gd 中无效的 Debug.invisible 引用

### 测试结果
- Godot 4.4.1 headless 导入：通过
- Godot headless 运行 battle 场景 30 帧：无脚本错误，exit 0
- `tests/smoke_test.gd`：stats / 伤害公式 / Combo / 常量 全部通过
- Git commit: `67e6984`

### 当前问题
- 需在有画面的编辑器/运行窗口中做手感验收（本机仅做了 headless 冒烟）
- 技能（鬼手/鬼影/鬼域）仅有 Skill 状态框架，具体技能数据未接完
- 动画与特效仍为占位

### 下一步
- 用 Godot 打开项目做手感测试：移动/跳跃/攻击/受击/伤害/击退/硬直/死亡/重置
- 接入杨间技能数据（鬼手、鬼影、鬼域、鬼眼压制、奥义占位）
- 扩展训练场（固定敌人开关、伤害数字）
