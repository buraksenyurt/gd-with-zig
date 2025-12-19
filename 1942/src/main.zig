const std = @import("std");
const _1942 = @import("_1942");
const rl = @import("raylib");
const config = @import("config.zig").Config;

var gameState: states = .Initial;

pub fn main() !void {
    rl.initWindow(config.screenWidth, config.screenHeight, "1942 Game in Zig with Raylib");
    defer rl.closeWindow();

    rl.setTargetFPS(config.fps);
    const titleText = rl.textFormat("1942 Game - Zig + Raylib\nPress ENTER to Start", .{});
    const sizeOfTitleText: f32 = @floatFromInt(
        rl.measureText(titleText, config.titleFontSize),
    );
    const gameOverText = "Game Over! Press R to Restart";
    const sizeOfGameOverText: f32 = @floatFromInt(
        rl.measureText(gameOverText, config.titleFontSize),
    );

    const playerTexture = try rl.loadTexture("resources/hero.png");
    defer rl.unloadTexture(playerTexture);

    var player = Player.init(playerTexture);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.blue.alpha(0.5));

        switch (gameState) {
            .Initial => {
                rl.drawText(
                    titleText,
                    @intFromFloat(config.screenWidth / 2 - sizeOfTitleText / 2),
                    (config.screenHeight / 2) - config.titleFontSize * 2,
                    config.titleFontSize,
                    rl.Color.white,
                );

                if (rl.isKeyPressed(rl.KeyboardKey.enter)) {
                    gameState = .Playing;
                }
            },
            .Playing => {
                player.update();
                player.draw();

                if (isGameOver()) {
                    gameState = .Ended;
                }
            },
            .Ended => {
                rl.drawText(
                    gameOverText,
                    @intFromFloat(config.screenWidth / 2 - sizeOfGameOverText / 2),
                    (config.screenHeight / 2) - config.titleFontSize * 2,
                    config.titleFontSize,
                    rl.Color.red,
                );
                if (rl.isKeyPressed(rl.KeyboardKey.r)) {
                    gameState = .Initial;
                }
            },
        }
    }
}

const states = enum {
    Initial,
    Playing,
    Ended,
};

fn isGameOver() bool {
    //todo@buraksenyurt: implement game over logic
    return false;
}

const Player = struct {
    position: rl.Vector2,
    size: rl.Vector2,
    asset: rl.Texture2D,

    pub fn init(texture: rl.Texture2D) @This() {
        return .{
            .position = rl.Vector2{
                .x = config.screenWidth / 2 - config.playerWidth / 2,
                .y = config.screenHeight - config.playerHeight,
            },
            .size = rl.Vector2{
                .x = config.playerWidth,
                .y = config.playerHeight,
            },
            .asset = texture,
        };
    }

    pub fn update(self: *@This()) void {
        if (rl.isKeyDown(rl.KeyboardKey.right)) {
            self.position.x += config.playerSpeed;
            if (self.position.x > @as(f32, @floatFromInt(config.screenWidth)) - self.size.x) {
                self.position.x = @as(f32, @floatFromInt(config.screenWidth)) - self.size.x;
            }
        }
        if (rl.isKeyDown(rl.KeyboardKey.left)) {
            self.position.x -= config.playerSpeed;
            if (self.position.x < 0) {
                self.position.x = 0;
            }
        }
        if (rl.isKeyDown(rl.KeyboardKey.up)) {
            self.position.y -= config.playerSpeed;
            if (self.position.y < 0) {
                self.position.y = 0;
            }
        }
        if (rl.isKeyDown(rl.KeyboardKey.down)) {
            self.position.y += config.playerSpeed;
            if (self.position.y > @as(f32, @floatFromInt(config.screenHeight)) - self.size.y) {
                self.position.y = @as(f32, @floatFromInt(config.screenHeight)) - self.size.y;
            }
        }
    }

    pub fn draw(self: @This()) void {
        rl.drawTexture(
            self.asset,
            @intFromFloat(self.position.x),
            @intFromFloat(self.position.y),
            rl.Color.white,
        );
    }

    pub fn getRectangle(self: *const Player) rl.Rectangle {
        return rl.Rectangle{
            .x = self.position.x,
            .y = self.position.y,
            .width = self.size.x,
            .height = self.size.y,
        };
    }
};
