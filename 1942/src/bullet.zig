const rl = @import("raylib");
const config = @import("config.zig").Config;

pub const Bullet = struct {
    position: rl.Vector2,
    size: rl.Vector2,
    asset: rl.Texture2D,
    isActive: bool = false,

    pub fn init(texture: rl.Texture2D) @This() {
        return .{
            .position = rl.Vector2{
                .x = 0,
                .y = 0,
            },
            .size = rl.Vector2{
                .x = 15.0,
                .y = 32.0,
            },
            .isActive = true,
            .asset = texture,
        };
    }

    pub fn update(self: *@This(), deltaTime: f32) void {
        if (!self.isActive) return;
        self.position.y -= config.BULLET_SPEED * deltaTime;
        if (self.position.y + self.size.y < 0) {
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
    }

    pub fn getRectangle(self: *const Bullet) rl.Rectangle {
        return rl.Rectangle{
            .x = self.position.x,
            .y = self.position.y,
            .width = self.size.x,
            .height = self.size.y,
        };
    }
};
