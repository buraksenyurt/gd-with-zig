const std = @import("std");
const rl = @import("raylib");
const config = @import("config.zig").Config;
const Player = @import("player.zig").Player;
const Game = @import("game.zig").Game;

pub fn main() !void {
    rl.setRandomSeed(@intCast(std.time.timestamp()));

    rl.initWindow(config.SCREEN_WIDTH, config.SCREEN_HEIGHT, "1942 Game in Zig with Raylib");
    defer rl.closeWindow();

    rl.setTargetFPS(config.FPS);
    const titleText = rl.textFormat("1942 Game - Zig + Raylib\nPress ENTER to Start", .{});
    const sizeOfTitleText: f32 = @floatFromInt(
        rl.measureText(titleText, config.TITLE_FONT_SIZE),
    );
    const gameOverText = "Game Over! Press R to Restart";
    const sizeOfGameOverText: f32 = @floatFromInt(
        rl.measureText(gameOverText, config.TITLE_FONT_SIZE),
    );
    const playerWinText = "You Win! Press R to Restart";
    const sizeOfPlayerWinText: f32 = @floatFromInt(
        rl.measureText(playerWinText, config.TITLE_FONT_SIZE),
    );

    const playerTexture = try rl.loadTexture("resources/hero.png");
    defer rl.unloadTexture(playerTexture);

    const bulletTexture = try rl.loadTexture("resources/bullet.png");
    defer rl.unloadTexture(bulletTexture);

    const botTexture = try rl.loadTexture("resources/bot.png");
    defer rl.unloadTexture(botTexture);

    const mineTexture = try rl.loadTexture("resources/mine.png");
    defer rl.unloadTexture(mineTexture);

    var game = Game.init();
    var player = Player.init(playerTexture, bulletTexture);
    try game.loadFormation(botTexture);
    try game.loadMines(mineTexture);

    while (!rl.windowShouldClose()) {
        const deltaTime = rl.getFrameTime();

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(config.BACKGROUND_COLOR);

        switch (game.state) {
            .Initial => {
                rl.drawText(
                    titleText,
                    @intFromFloat(config.SCREEN_WIDTH / 2 - sizeOfTitleText / 2),
                    (config.SCREEN_HEIGHT / 2) - config.TITLE_FONT_SIZE * 2,
                    config.TITLE_FONT_SIZE,
                    rl.Color.white,
                );

                if (rl.isKeyPressed(rl.KeyboardKey.enter)) {
                    game.state = .Playing;
                }
            },
            .Playing => {
                if (game.remainingBots == 0) {
                    game.state = .PlayerWin;
                }

                player.update(deltaTime);
                player.draw();

                for (player.bullets[0..]) |*b| {
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
                        if (rl.checkCollisionRecs(player.getRectangle(), bot.getRectangle())) {
                            game.state = .PlayerLoose;
                        }
                    }
                }

                for (game.mine[0..]) |*m| {
                    if (m.isActive) {
                        if (rl.checkCollisionRecs(player.getRectangle(), m.getRectangle())) {
                            game.state = .PlayerLoose;
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
                rl.drawText(
                    playerWinText,
                    @intFromFloat(config.SCREEN_WIDTH / 2 - sizeOfPlayerWinText / 2),
                    (config.SCREEN_HEIGHT / 2) - config.TITLE_FONT_SIZE * 2,
                    config.TITLE_FONT_SIZE,
                    rl.Color.green,
                );
                if (rl.isKeyPressed(rl.KeyboardKey.r)) {
                    game.state = .Initial;
                }
            },
            .PlayerLoose => {
                rl.drawText(
                    gameOverText,
                    @intFromFloat(config.SCREEN_WIDTH / 2 - sizeOfGameOverText / 2),
                    (config.SCREEN_HEIGHT / 2) - config.TITLE_FONT_SIZE * 2,
                    config.TITLE_FONT_SIZE,
                    rl.Color.red,
                );
                if (rl.isKeyPressed(rl.KeyboardKey.r)) {
                    game.state = .Initial;
                }
            },
        }
    }
}
