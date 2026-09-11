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
- 鬼眼压制默认无独立键位，需从技能管理器调用或后续绑键
- 动画与特效仍为占位
- AI 不会主动用灵异技能

### 下一步
- 训练场伤害飘字 / 固定敌人
- AI 使用技能
- 手感与平衡数值微调

---

## [2026-09-11] 杨间技能接入

### 本轮目标
- 完成杨间灵异技能：鬼手 / 鬼影 / 鬼域 / 鬼眼压制 / 奥义

### 已完成
- `SkillData` 扩展 effect_type 与技能参数
- `YangJianKit` 五技能数值包
- `SkillManager` 冷却/灵异消耗/按键分发
- 鬼手：命中拉拽
- 鬼影：本体 + 延迟追击
- 鬼域：自身加速加伤、敌方减速、占位光环
- 鬼眼压制：不可防短锁
- 奥义：开域 + 多段 + 终结击飞（需 100 灵异）
- Idle/Walk/Attack 可释放技能；领域吃移动/冲刺速度
- HUD 提示更新；冒烟测试覆盖技能包

### 测试结果
- headless 游戏运行 exit 0
- smoke_test：全部通过（含 5 技能与奥义消耗）

---

## [2026-09-11] 反馈与 AI 技能

### 本轮目标
- 伤害飘字、AI 放技能、HUD 技能冷却/复苏危险提示

### 已完成
- `DamagePopup` 受击飘字（普通/重击着色）
- 占位敌人技能包 `PlaceholderKit`（灵异爆发 / 厉鬼冲击）
- AI 按距离与灵异值释放技能；杨间 AI 会开鬼域/奥义
- HUD 左下技能槽：冷却填充 + 灵力不足变暗
- 复苏值激活时红脉冲；鬼域中灵异条染紫

### 测试结果
- headless 游戏 exit 0；smoke_test 通过

### 下一步
- 训练模式固定敌人 / 重置快捷
- VS 正式胜负流程打磨
- 第二角色（叶真）骨架

---

## [2026-09-11] 训练工具与 VS 流程

### 已完成
- **F8** 木桩模式：敌方 AI 停止，站桩挨打
- **F9** 复位：双方回出生点并回满状态（不重载场景）
- **F6** 无敌现已作用于玩家
- **Tab** 训练 ⇄ VS 切换（重载场景保留偏好）
- VS **99s 计时**，时间到按剩余 HP 判定胜负
- 击杀胜负结算文案 + 自动再战

### 测试结果
- headless exit 0

### 下一步
- 主菜单 / 角色选择骨架
- 叶真第二角色
- 更完整的训练统计（最高连段等）

---

## [2026-09-11] 主菜单 + 选人 + 叶真

### 已完成
- 主菜单：训练 / VS / 退出（主场景）
- 角色选择：P1 杨间/叶真，CPU 可选占位/杨间/叶真
- `CharacterRegistry` 统一角色表
- **叶真**：铁冲 / 崩拳 / 铁壁无敌 / 霸体重击 / 奥义绝对反击
- 角色级：超级霸体（吃伤害不硬直）、无敌 buff
- VS 结算后回主菜单；Esc 回菜单

### 测试结果
- headless exit 0；smoke 含叶真与注册表断言

### 下一步
- 训练统计、第二地图
- 叶真平衡与 AI 技能表完善
- 打击特效/音效占位
