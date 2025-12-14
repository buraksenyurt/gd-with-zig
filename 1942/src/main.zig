const std = @import("std");
const _1942 = @import("_1942");
const rl = @import("raylib");
const config = @import("config.zig").Config;

pub fn main() !void {
    rl.initWindow(config.screenWidth, config.screenHeight, "1942 Game in Zig with Raylib");
    defer rl.closeWindow();

    rl.setTargetFPS(config.fps);
    const titleText = rl.textFormat("1942 Game - Zig + Raylib", .{});
    const sizeOfText: f32 = @floatFromInt(
        rl.measureText(titleText, config.titleFontSize),
    );

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.blue.alpha(0.5));

        rl.drawText(
            titleText,
            @intFromFloat(config.screenWidth / 2 - sizeOfText / 2),
            (config.screenHeight / 2) - config.titleFontSize,
            config.titleFontSize,
            rl.Color.white,
        );
    }
}
