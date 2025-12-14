const rl = @import("raylib");
const std = @import("std");
const config = @import("config.zig").Config;
const Block = @import("block.zig").Block;
const colorUtils = @import("color.zig").ColorUtils;
const Game = @import("game.zig").Game;

pub fn main() !void {
    rl.setRandomSeed(@intCast(std.time.timestamp()));

    var game = Game{};
    game.init();

    rl.initWindow(800, 740, "Blocks Game in Zig with Raylib");
    defer rl.closeWindow();

    rl.setTargetFPS(60);
    const ferris = try rl.loadTexture("resources/ferris_00.png");
    defer rl.unloadTexture(ferris);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);

        rl.drawTexture(ferris, 10, 610, rl.Color.white);

        game.Update();

        for (game.blocks) |block| {
            block.draw();
        }

        game.draw();
    }
}
