const rl = @import("raylib");
const config = @import("config.zig").Config;
const Bot = @import("bot.zig").Bot;
const Cell = @import("formation.zig").Cell;
const Mine = @import("mine.zig").Mine;
const Formations = @import("formation.zig").FORMATION;

pub const States = enum {
    Initial,
    Playing,
    PlayerWin,
    PlayerLoose,
};

pub const Game = struct {
    bots: [config.MAX_BOT_COUNT]Bot = undefined,
    mine: [config.MAX_MINE_COUNT]Mine = undefined,
    activeBotCount: usize = 0,
    state: States = .Initial,
    score: u32 = 0,
    remainingBots: usize = 0,

    pub fn init() @This() {
        return .{};
    }

    fn getRandomFormation() [config.F_ROW_COUNT][config.F_COL_COUNT]Cell {
        const randIndex = @as(usize, @intCast(rl.getRandomValue(0, Formations.len - 1)));
        // std.log.info("Selected Formation Index: {d}\n", .{randIndex});
        return Formations[randIndex];
    }

    pub fn loadFormation(self: *@This(), botTexture: rl.Texture2D) !void {
        const formation = getRandomFormation();
        const formationWidth: f32 = config.F_COL_COUNT * config.BOT_WIDTH;
        const offsetX: f32 = (@as(f32, @floatFromInt(config.SCREEN_WIDTH)) - formationWidth) / 2.0;
        const offsetY: f32 = config.FORMATION_START_Y;

        var counter: usize = 0;
        for (formation, 0..) |row, rowIndex| {
            for (row, 0..) |cell, colIndex| {
                if (cell == Cell.Bot) {
                    const startX = offsetX + @as(f32, @floatFromInt((colIndex * @as(usize, config.BOT_WIDTH))));
                    const startY = offsetY + @as(f32, @floatFromInt((rowIndex * @as(usize, config.BOT_HEIGHT))));
                    const b = Bot.init(botTexture, startX, startY);
                    self.bots[counter] = b;
                    self.remainingBots += 1;
                    counter += 1;
                }
            }
        }
        self.activeBotCount = counter;
    }

    pub fn loadMines(self: *@This(), mineTexture: rl.Texture2D) !void {
        for (self.mine[0..]) |*m| {
            m.*.asset = mineTexture;
            m.*.position = rl.Vector2{
                .x = @floatFromInt(rl.getRandomValue(0, config.SCREEN_WIDTH - config.MINE_WIDTH)),
                .y = @floatFromInt(rl.getRandomValue(0, config.SCREEN_HEIGHT / 2)),
            };
            m.*.size = rl.Vector2{
                .x = config.MINE_WIDTH,
                .y = config.MINE_HEIGHT,
            };
            m.*.isActive = true;
            // m.*.wakeUpTime = @floatFromInt(rl.getRandomValue(3, 8));
            m.*.maxLifetime = @floatFromInt(rl.getRandomValue(3, 12));
        }
    }
};
