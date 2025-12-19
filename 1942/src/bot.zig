const rl = @import("raylib");
const config = @import("config.zig").Config;

pub const Bot = struct {
    position: rl.Vector2,
    size: rl.Vector2,
    asset: rl.Texture2D,

    pub fn init(texture: rl.Texture2D, startX: f32, startY: f32) @This() {
        // std.log.info("Creating Bot at position ({d}, {d})\n", .{ startX, startY });
        return .{
            .position = rl.Vector2{
                .x = startX,
                .y = startY,
            },
            .size = rl.Vector2{
                .x = config.BOT_WIDTH,
                .y = config.BOT_HEIGHT,
            },
            .asset = texture,
        };
    }

    pub fn update(self: *@This(), deltaTime: f32) void {
        self.position.y += config.BOT_SPEED * deltaTime;
        if (self.position.y > @as(f32, config.SCREEN_HEIGHT)) {
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
