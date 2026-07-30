package main

import "core:fmt"
import rl "vendor:raylib"

GRAVITY        :: 2000.0
JUMP_VELOCITY  :: -700.0
MOVE_SPEED     :: 300.0
PLAYER_SIZE    :: 30.0

Player :: struct {
	pos:        rl.Vector2,
	vel:        rl.Vector2,
	isGrounded: bool,
}

check_collision :: proc(box1, box2: rl.Rectangle) -> bool {
	return (box1.x < box2.x + box2.width &&
		box1.x + box1.width > box2.x &&
		box1.y < box2.y + box2.height &&
		box1.y + box1.height > box2.y)
}

get_player_rect :: proc(p: Player) -> rl.Rectangle {
	return rl.Rectangle {
		p.pos.x - PLAYER_SIZE / 2,
		p.pos.y - PLAYER_SIZE / 2,
		PLAYER_SIZE,
		PLAYER_SIZE,
	}
}

main :: proc() {
	rl.InitWindow(800, 450, "cool platformer!")
	defer rl.CloseWindow()

	player := Player {
		pos        = rl.Vector2{400, 20},
		vel        = rl.Vector2{0, 0},
		isGrounded = false,
	}

	rl.SetTargetFPS(60)

	platform := rl.Rectangle{400 - 200 / 2, 400, 200, 30}

	for !rl.WindowShouldClose() {
    dt := rl.GetFrameTime()

    player.vel.x = 0
    if rl.IsKeyDown(rl.KeyboardKey.LEFT) || rl.IsKeyDown(rl.KeyboardKey.A) {
        player.vel.x -= MOVE_SPEED
    }
    if rl.IsKeyDown(rl.KeyboardKey.RIGHT) || rl.IsKeyDown(rl.KeyboardKey.D) {
        player.vel.x += MOVE_SPEED
    }

    player.vel.y += GRAVITY * dt

    jumpPressed := rl.IsKeyPressed(rl.KeyboardKey.SPACE) ||
        rl.IsKeyPressed(rl.KeyboardKey.UP) ||
        rl.IsKeyPressed(rl.KeyboardKey.W)
    if player.isGrounded && jumpPressed {
        player.vel.y = JUMP_VELOCITY
    }

    player.pos.x += player.vel.x * dt
    player.pos.y += player.vel.y * dt

    playerRect := get_player_rect(player)
    if player.vel.y >= 0 && check_collision(playerRect, platform) {
        player.pos.y = platform.y - PLAYER_SIZE / 2
        player.vel.y = 0
        player.isGrounded = true
    } else {
        player.isGrounded = false
    }

    playerRect = get_player_rect(player)

    rl.BeginDrawing()
    rl.ClearBackground(rl.BLACK)
    rl.DrawRectangleRec(platform, rl.DARKGRAY)
    rl.DrawRectangleRec(playerRect, rl.GREEN)
    rl.EndDrawing()
	}
}
