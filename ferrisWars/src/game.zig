const rl = @import("raylib");
const config = @import("config.zig").Config;
const Bot = @import("bot.zig").Bot;
const Cell = @import("formation.zig").Cell;
const Mine = @import("mine.zig").Mine;
const Player = @import("player.zig").Player;
const Formations = @import("formation.zig").FORMATION;
const AssetServer = @import("assetServer.zig").AssetServer;
const Explosion = @import("animations.zig").ExplosionAnimation;
const MineAnimation = @import("animations.zig").MineAnimation;

pub const States = enum {
    Initial,
    Playing,
    PlayerWin,
    PlayerLoose,
};

pub const Game = struct {
    player: Player,
    bots: [config.MAX_BOT_COUNT]Bot = undefined,
    mine: [config.MAX_MINE_COUNT]Mine = undefined,
    explosions: [config.MAX_EXPLOSION_COUNT]Explosion = undefined,
    activeBotCount: usize = 0,
    state: States = .Initial,
    score: u32 = 0,
    remainingBots: usize = 0,
    assetServer: AssetServer,
    winningSoundPlayed: bool = false,
    losingSoundPlayed: bool = false,

    pub fn init(
        assetServer: AssetServer,
    ) !@This() {
        var game = @This(){
            .player = undefined,
            .bots = undefined,
            .mine = undefined,
            .explosions = undefined,
            .activeBotCount = 0,
            .state = .Initial,
            .score = 0,
            .remainingBots = 0,
            .assetServer = undefined,
        };
        game.player = Player.init(assetServer);
        game.assetServer = assetServer;

        for (game.explosions[0..]) |*e| {
            e.* = Explosion.init(assetServer);
        }

        try game.loadFormation();
        try game.loadMines();
        return game;
    }

    pub fn reset(self: *@This()) !void {
        self.state = .Initial;
        self.score = 0;
        self.activeBotCount = 0;
        self.remainingBots = 0;
        self.player.bulletCooldown = 0.0;
        self.player.totalBulletsFired = 0;
        self.losingSoundPlayed = false;
        self.winningSoundPlayed = false;
        self.player.position = rl.Vector2{
            .x = config.SCREEN_WIDTH / 2 - config.PLAYER_WIDTH / 2,
            .y = config.AREA_HEIGHT - config.PLAYER_HEIGHT,
        };
        for (self.player.bullets[0..]) |*b| {
            b.*.isActive = false;
            b.*.position = rl.Vector2{
                .x = 0,
                .y = 0,
            };
        }
        for (self.bots[0..]) |*bot| {
            bot.*.isActive = false;
        }
        for (self.mine[0..]) |*m| {
            m.*.isActive = false;
        }
        for (self.explosions[0..]) |*e| {
            e.*.isActive = false;
        }
        _ = try self.loadFormation();
        _ = try self.loadMines();
    }

    fn getRandomFormation() [config.FORMATION_ROW_COUNT][config.FORMATION_COL_COUNT]Cell {
        const randIndex = @as(usize, @intCast(rl.getRandomValue(0, Formations.len - 1)));
        // std.log.info("Selected Formation Index: {d}\n", .{randIndex});
        return Formations[randIndex];
    }

    fn loadFormation(self: *@This()) !void {
        const formation = getRandomFormation();
        const formationWidth: f32 = config.FORMATION_COL_COUNT * config.BOT_WIDTH;
        const offsetX: f32 = (@as(f32, @floatFromInt(config.SCREEN_WIDTH)) - formationWidth) / 2.0;
        const offsetY: f32 = config.FORMATION_START_Y;

        var counter: usize = 0;
        for (formation, 0..) |row, rowIndex| {
            for (row, 0..) |cell, colIndex| {
                if (cell == Cell.Bot) {
                    const startX = offsetX + @as(f32, @floatFromInt((colIndex * @as(usize, config.BOT_WIDTH))));
                    const startY = offsetY + @as(f32, @floatFromInt((rowIndex * @as(usize, config.BOT_HEIGHT))));
                    const b = Bot.init(self.assetServer, startX, startY);
                    self.bots[counter] = b;
                    self.remainingBots += 1;
                    counter += 1;
                }
            }
        }
        self.activeBotCount = counter;
    }

    fn loadMines(self: *@This()) !void {
        for (self.mine[0..], 0..) |*m, index| {
            m.*.animation = MineAnimation.init(self.assetServer);
            m.*.size = rl.Vector2{
                .x = config.MINE_WIDTH,
                .y = config.MINE_HEIGHT,
            };

            var validPosition = false;
            var attempts: usize = 0;

            while (!validPosition and attempts < config.MINE_MAX_LOCATIONS_ATTEMPTS) {
                const x = @as(f32, @floatFromInt(rl.getRandomValue(0, config.SCREEN_WIDTH - @as(i32, @intFromFloat(config.MINE_WIDTH * 2)))));
                const y = @as(f32, @floatFromInt(rl.getRandomValue(@as(i32, @intFromFloat(config.MINE_HEIGHT * 2)), @as(i32, config.AREA_HEIGHT / 2))));

                validPosition = true;
                for (self.mine[0..index]) |other| {
                    const dx = x - other.position.x;
                    const dy = y - other.position.y;
                    const distance = @sqrt(dx * dx + dy * dy);

                    if (distance < config.MINE_DISTANCE) {
                        validPosition = false;
                        break;
                    }
                }

                if (validPosition) {
                    m.*.position = rl.Vector2{ .x = x, .y = y };
                }

                attempts += 1;
            }

            if (!validPosition) {
                m.*.position = rl.Vector2{
                    .x = @floatFromInt(rl.getRandomValue(0, config.SCREEN_WIDTH - @as(i32, @intFromFloat(config.MINE_WIDTH * 2)))),
                    .y = @floatFromInt(rl.getRandomValue(@as(i32, @intFromFloat(config.MINE_HEIGHT * 2)), @as(i32, config.AREA_HEIGHT / 2))),
                };
            }

            m.*.isActive = true;
            m.*.animation.spawn(m.position.x, m.position.y);
            m.*.maxLifetime = @floatFromInt(rl.getRandomValue(@as(i32, @intFromFloat(config.MINE_LIFETIME_RANGE[0])), @as(i32, @intFromFloat(config.MINE_LIFETIME_RANGE[1]))));
        }
    }

    pub fn spawnExplosion(self: *@This(), x: f32, y: f32) void {
        for (self.explosions[0..]) |*e| {
            if (!e.isActive) {
                e.spawn(x, y);
                break;
            }
        }
    }
};
