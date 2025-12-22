const std = @import("std");
const rl = @import("raylib");
const config = @import("config.zig").Config;
const Player = @import("player.zig").Player;
const Game = @import("game.zig").Game;
const AssetServer = @import("assetServer.zig").AssetServer;
const TextBlock = @import("textBlock.zig").TextBlock;
const TextAlignment = @import("textBlock.zig").TextAlignment;
const Designer = @import("designer.zig");

pub fn main() !void {
    rl.setRandomSeed(@intCast(std.time.timestamp()));

    rl.initWindow(config.SCREEN_WIDTH, config.SCREEN_HEIGHT, "Ferris Wars Game in Zig with Raylib");
    defer rl.closeWindow();

    rl.setTargetFPS(config.FPS);

    const assetServer = try AssetServer.load();

    var game = try Game.init(
        assetServer,
    );
    defer assetServer.unload();

    gameLoop: while (!rl.windowShouldClose()) {
        const deltaTime = rl.getFrameTime();

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(config.BACKGROUND_COLOR);

        rl.drawRectangle(
            0,
            config.AREA_HEIGHT,
            config.SCREEN_WIDTH,
            config.SCREEN_HEIGHT - config.AREA_HEIGHT,
            config.HUD_BACKGROUND_COLOR,
        );
        Designer.hudText.draw(
            .Left,
            .{ game.score, game.remainingBots, game.player.totalBulletsFired },
        );

        switch (game.state) {
            .Initial => {
                rl.drawTexture(
                    assetServer.cover,
                    0,
                    0,
                    rl.Color.white,
                );

                if (rl.isKeyPressed(rl.KeyboardKey.enter) or rl.isMouseButtonPressed(rl.MouseButton.left)) {
                    game.state = .Playing;
                }
            },
            .Playing => {
                if (game.remainingBots == 0) {
                    game.state = .PlayerWin;
                    continue :gameLoop;
                }

                game.player.update(deltaTime);
                game.player.draw();

                for (game.player.bullets[0..]) |*b| {
                    for (game.bots[0..game.activeBotCount]) |*bot| {
                        if (b.isActive and bot.isActive) {
                            if (rl.checkCollisionRecs(b.getRectangle(), bot.getRectangle())) {
                                b.isActive = false;
                                bot.isActive = false;
                                game.score += 10;
                                game.remainingBots -= 1;
                            }
                        }
                    }
                }

                for (game.bots[0..]) |*bot| {
                    if (bot.isActive) {
                        if (rl.checkCollisionRecs(game.player.getRectangle(), bot.getRectangle())) {
                            game.state = .PlayerLoose;
                            continue :gameLoop;
                        }
                    }
                }

                for (game.mine[0..]) |*m| {
                    if (m.isActive) {
                        if (rl.checkCollisionRecs(game.player.getRectangle(), m.getRectangle())) {
                            game.state = .PlayerLoose;
                            continue :gameLoop;
                        }
                    }
                }

                for (game.bots[0..game.activeBotCount]) |*bot| {
                    bot.update(deltaTime);
                }
                for (game.bots[0..game.activeBotCount]) |bot| {
                    bot.draw();
                }
                for (game.mine[0..]) |*m| {
                    m.update(deltaTime);
                    m.draw();
                }
            },
            .PlayerWin => {
                rl.clearBackground(config.WIN_BACKGROUND_COLOR);
                Designer.playerWinText.draw(TextAlignment.Center, .{});
                if (rl.isKeyPressed(rl.KeyboardKey.r)) {
                    try game.reset();
                    continue :gameLoop;
                }
            },
            .PlayerLoose => {
                rl.clearBackground(config.LOOSE_BACKGROUND_COLOR);
                Designer.gameOverText.draw(TextAlignment.Center, .{});

                if (rl.isKeyPressed(rl.KeyboardKey.r)) {
                    try game.reset();
                    continue :gameLoop;
                }
            },
        }
    }
}
