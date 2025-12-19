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
    const sizeOfText: f32 = @floatFromInt(
        rl.measureText(titleText, config.titleFontSize),
    );

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.blue.alpha(0.5));

        switch (gameState) {
            .Initial => {
                rl.drawText(
                    titleText,
                    @intFromFloat(config.screenWidth / 2 - sizeOfText / 2),
                    (config.screenHeight / 2) - config.titleFontSize * 2,
                    config.titleFontSize,
                    rl.Color.white,
                );

                if (rl.isKeyPressed(rl.KeyboardKey.enter)) {
                    gameState = .Playing;
                }
            },
            .Playing => {
                //todo@buraksenyurt: implement game update and draw logic

                if (isGameOver()) {
                    gameState = .Ended;
                }
            },
            .Ended => {
                rl.drawText("Game Over! Press R to Restart", 150, 400, 20, rl.Color.red);
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
