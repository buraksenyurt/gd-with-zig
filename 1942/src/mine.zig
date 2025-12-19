const rl = @import("raylib");
const config = @import("config.zig").Config;
const std = @import("std");

pub const Mine = struct {
    position: rl.Vector2,
    size: rl.Vector2,
    asset: rl.Texture2D,
    isActive: bool = false,
    currentLifetime: f32 = 0.0,
    maxLifetime: f32 = 0.0,
    wakeUpTime: f32 = 0.0,

    pub fn update(self: *@This(), deltaTime: f32) void {
        if (!self.isActive) return;
        self.currentLifetime += deltaTime;
        if (self.currentLifetime >= self.maxLifetime) {
            self.isActive = false;
        }
    }

    pub fn draw(self: @This()) void {
        if (!self.isActive) return;
        rl.drawTexture(
            self.asset,
            @intFromFloat(self.position.x),
            @intFromFloat(self.position.y),
            rl.Color.white,
        );
        const text = rl.textFormat("%d", .{self.currentLifetime});
        // std.log.info("Mine Lifetime: {}\n", .{self.currentLifetime});
        rl.drawText(
            text,
            @intFromFloat(self.position.x),
            @intFromFloat(self.position.y - 20.0),
            10,
            rl.Color.red,
        );
    }

    pub fn getRectangle(self: *const Mine) rl.Rectangle {
        return rl.Rectangle{
            .x = self.position.x,
            .y = self.position.y,
            .width = self.size.x,
            .height = self.size.y,
        };
    }
};
