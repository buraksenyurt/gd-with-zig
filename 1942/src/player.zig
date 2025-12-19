const rl = @import("raylib");
const config = @import("config.zig").Config;
const std = @import("std");

pub const Player = struct {
    position: rl.Vector2,
    size: rl.Vector2,
    asset: rl.Texture2D,

    pub fn init(texture: rl.Texture2D) @This() {
        return .{
            .position = rl.Vector2{
                .x = config.SCREEN_WIDTH / 2 - config.PLAYER_WIDTH / 2,
                .y = config.SCREEN_HEIGHT - config.PLAYER_HEIGHT,
            },
            .size = rl.Vector2{
                .x = config.PLAYER_WIDTH,
                .y = config.PLAYER_HEIGHT,
            },
            .asset = texture,
        };
    }

    pub fn update(self: *@This(), deltaTime: f32) void {
        const movement = config.PLAYER_SPEED * deltaTime;

        if (rl.isKeyDown(rl.KeyboardKey.right)) {
            self.position.x += movement;
            if (self.position.x > @as(f32, @floatFromInt(config.SCREEN_WIDTH)) - self.size.x) {
                self.position.x = @as(f32, @floatFromInt(config.SCREEN_WIDTH)) - self.size.x;
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
            if (self.position.y > @as(f32, @floatFromInt(config.SCREEN_HEIGHT)) - self.size.y) {
                self.position.y = @as(f32, @floatFromInt(config.SCREEN_HEIGHT)) - self.size.y;
            }
        }
    }

    pub fn draw(self: @This()) void {
        const x = @max(@min(self.position.x, @as(f32, @floatFromInt(std.math.maxInt(i32)))), @as(f32, @floatFromInt(std.math.minInt(i32))));
        const y = @max(@min(self.position.y, @as(f32, @floatFromInt(std.math.maxInt(i32)))), @as(f32, @floatFromInt(std.math.minInt(i32))));

        rl.drawTexture(
            self.asset,
            @intFromFloat(x),
            @intFromFloat(y),
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
