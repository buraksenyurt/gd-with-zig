const rl = @import("raylib");
const JumperAnimation = @import("animations.zig").JumperAnimation;

pub const Jumper = struct {
    position: rl.Vector2,
    size: rl.Vector2,
    animation: JumperAnimation,
    isActive: bool = false,

    pub fn update(self: *@This(), deltaTime: f32) void {
        if (!self.isActive) return;
        self.animation.update(deltaTime);
    }

    pub fn move(self: *@This(), deltaX: f32, deltaY: f32) void {
        if (!self.isActive) return;
        self.position.x += deltaX;
        self.position.y += deltaY;
    }

    pub fn draw(self: @This()) void {
        if (!self.isActive) return;
        self.animation.draw();
    }

    pub fn getRectangle(self: *const @This()) rl.Rectangle {
        return rl.Rectangle{
            .x = self.position.x,
            .y = self.position.y,
            .width = self.size.x,
            .height = self.size.y,
        };
    }
};
