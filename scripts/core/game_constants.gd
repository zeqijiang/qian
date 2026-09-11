class_name GameConstants
extends RefCounted

# Physics layers (bit masks)
const LAYER_WORLD := 1
const LAYER_PLAYER := 2
const LAYER_ENEMY := 4
const LAYER_HITBOX := 8
const LAYER_HURTBOX := 16

# Facing
const FACING_RIGHT := 1
const FACING_LEFT := -1

# Combat
const DEFAULT_COMBO_WINDOW := 0.8
const DEFAULT_HITSTUN := 0.15
const DEFAULT_BLOCKSTUN := 0.1
const DEFAULT_KNOCKBACK := 120.0
const GRAVITY := 1800.0
const MAX_FALL_SPEED := 1200.0

# Energy
const MAX_SPIRIT := 100.0
const MAX_REVIVAL := 100.0
const REVIVAL_THRESHOLD := 80.0
