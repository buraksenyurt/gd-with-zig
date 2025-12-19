const std = @import("std");
const _1942 = @import("_1942");
const rl = @import("raylib");
const config = @import("config.zig").Config;

var gameState: states = .Initial;

pub fn main() !void {
    rl.setRandomSeed(@intCast(std.time.timestamp()));
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

    const botTexture = try rl.loadTexture("resources/bot.png");
    defer rl.unloadTexture(botTexture);

    var player = Player.init(playerTexture);
    var bots: [config.maxBots]Bot = undefined;
    const formation = getRandomFormation();

    const formationWidth: f32 = config.fColCount * config.botWidth;

    const offsetX: f32 = (@as(f32, @floatFromInt(config.screenWidth)) - formationWidth) / 2.0;
    const offsetY: f32 = -300.0;

    var counter: usize = 0;
    for (formation, 0..) |row, rowIndex| {
        for (row, 0..) |cell, colIndex| {
            if (cell == Cell.Bot) {
                const startX = offsetX + @as(f32, @floatFromInt((colIndex * @as(usize, config.botWidth))));
                const startY = offsetY + @as(f32, @floatFromInt((rowIndex * @as(usize, config.botHeight))));
                const b = Bot.init(botTexture, startX, startY);
                bots[counter] = b;
                counter += 1;
            }
        }
    }

    // for (0..bots.len) |index| {
    //     const startX = @as(f32, @floatFromInt((index * 64) + 32));
    //     const startY: f32 = -150.0;
    //     const b = Bot.init(botTexture, startX, startY);
    //     bots[index] = b;
    // }

    while (!rl.windowShouldClose()) {
        const deltaTime = rl.getFrameTime();

        rl.beginDrawing();
        defer rl.endDrawing();

        const backgroundColor = rl.Color{ .r = 190, .g = 136, .b = 113, .a = 100 };
        rl.clearBackground(backgroundColor);

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
                player.update(deltaTime);
                player.draw();

                for (&bots) |*bot| {
                    bot.update(deltaTime);
                }
                for (&bots) |bot| {
                    bot.draw();
                }

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

    pub fn update(self: *@This(), deltaTime: f32) void {
        const movement = config.playerSpeed * deltaTime;

        if (rl.isKeyDown(rl.KeyboardKey.right)) {
            self.position.x += movement;
            if (self.position.x > @as(f32, @floatFromInt(config.screenWidth)) - self.size.x) {
                self.position.x = @as(f32, @floatFromInt(config.screenWidth)) - self.size.x;
            }
        }
        if (rl.isKeyDown(rl.KeyboardKey.left)) {
            self.position.x -= movement;
            if (self.position.x < 0) {
                self.position.x = 0;
            }
        }
        if (rl.isKeyDown(rl.KeyboardKey.up)) {
            self.position.y -= movement;
            if (self.position.y < 0) {
                self.position.y = 0;
            }
        }
        if (rl.isKeyDown(rl.KeyboardKey.down)) {
            self.position.y += movement;
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

const Bot = struct {
    position: rl.Vector2,
    size: rl.Vector2,
    asset: rl.Texture2D,

    pub fn init(texture: rl.Texture2D, startX: f32, startY: f32) @This() {
        return .{
            .position = rl.Vector2{
                .x = startX,
                .y = startY,
            },
            .size = rl.Vector2{
                .x = config.botWidth,
                .y = config.botHeight,
            },
            .asset = texture,
        };
    }

    pub fn update(self: *@This(), deltaTime: f32) void {
        self.position.y += config.botSpeed * deltaTime;
        if (self.position.y > @as(f32, config.screenHeight)) {
            self.position.y = -self.size.y;
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

    pub fn getRectangle(self: *const Bot) rl.Rectangle {
        return rl.Rectangle{
            .x = self.position.x,
            .y = self.position.y,
            .width = self.size.x,
            .height = self.size.y,
        };
    }
};

const Cell = enum(u8) {
    Empty = 0,
    Bot = 1,
};

const formations = [_][config.fRowCount][config.fColCount]Cell{
    .{
        .{ .Empty, .Empty, .Empty, .Empty, .Empty },
        .{ .Bot, .Empty, .Empty, .Empty, .Bot },
        .{ .Empty, .Bot, .Empty, .Bot, .Empty },
        .{ .Empty, .Empty, .Bot, .Empty, .Empty },
    },
    .{
        .{ .Empty, .Empty, .Empty, .Empty, .Empty },
        .{ .Empty, .Bot, .Empty, .Bot, .Empty },
        .{ .Bot, .Empty, .Bot, .Empty, .Bot },
        .{ .Empty, .Bot, .Empty, .Bot, .Empty },
    },
    .{
        .{ .Empty, .Bot, .Empty, .Bot, .Empty },
        .{ .Bot, .Empty, .Bot, .Empty, .Bot },
        .{ .Empty, .Bot, .Empty, .Bot, .Empty },
        .{ .Bot, .Empty, .Bot, .Empty, .Bot },
    },
    .{
        .{ .Bot, .Empty, .Bot, .Empty, .Bot },
        .{ .Bot, .Empty, .Bot, .Empty, .Bot },
        .{ .Bot, .Empty, .Bot, .Empty, .Bot },
        .{ .Bot, .Empty, .Bot, .Empty, .Bot },
    },
};

fn getRandomFormation() [config.fRowCount][config.fColCount]Cell {
    const randIndex = @as(usize, @intCast(rl.getRandomValue(0, formations.len - 1)));
    return formations[randIndex];
}
