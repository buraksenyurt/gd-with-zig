const rl = @import("raylib");
const config = @import("config.zig").Config;

pub const Explosion = struct {
    position: rl.Vector2,
    isActive: bool = false,
    currentFrame: usize = 0,
    frameTimer: f32 = 0.0,
    frameDuration: f32 = 0.2,
    spriteSheet: rl.Texture2D,

    const FRAME_ORDER = [7]usize{ 0, 1, 2, 3, 2, 1, 0 };

    const FRAME_RECTS = [4]rl.Rectangle{
        .{ .x = 1, .y = 1, .width = 96, .height = 96 },
        .{ .x = 99, .y = 1, .width = 96, .height = 96 },
        .{ .x = 197, .y = 1, .width = 96, .height = 96 },
        .{ .x = 295, .y = 1, .width = 96, .height = 96 },
    };

    pub fn init(spriteSheet: rl.Texture2D) @This() {
        return .{
            .position = rl.Vector2{ .x = 0, .y = 0 },
            .isActive = false,
            .spriteSheet = spriteSheet,
        };
    }

    pub fn spawn(self: *@This(), x: f32, y: f32) void {
        self.position = rl.Vector2{ .x = x, .y = y };
        self.isActive = true;
        self.currentFrame = 0;
        self.frameTimer = 0.0;
    }

    pub fn update(self: *@This(), deltaTime: f32) void {
        if (!self.isActive) return;

        self.frameTimer += deltaTime;
        if (self.frameTimer >= self.frameDuration) {
            self.frameTimer = 0.0;
            self.currentFrame += 1;

            if (self.currentFrame >= FRAME_ORDER.len) {
                self.isActive = false;
            }
        }
    }

    pub fn draw(self: @This()) void {
        if (!self.isActive) return;

        const frameIndex = FRAME_ORDER[self.currentFrame];
        const sourceRect = FRAME_RECTS[frameIndex];

        const scale: f32 = 0.8;
        const destRect = rl.Rectangle{
            .x = self.position.x,
            .y = self.position.y,
            .width = sourceRect.width * scale,
            .height = sourceRect.height * scale,
        };

        rl.drawTexturePro(
            self.spriteSheet,
            sourceRect,
            destRect,
            rl.Vector2{ .x = 0, .y = 0 },
            0.0,
            rl.Color.white,
        );
    }
};
