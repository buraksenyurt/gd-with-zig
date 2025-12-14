const rl = @import("raylib");
const std = @import("std");
const config = @import("config.zig").Config;
const colorUtils = @import("color.zig").ColorUtils;

pub const Block = struct {
    id: u32,
    x: i32,
    y: i32,
    width: i32,
    height: i32,
    coverColor: rl.Color,
    realColor: rl.Color,
    inRealColorMode: bool = false,
    isActive: bool = true,

    pub fn init(id: u32, x: i32, y: i32, width: i32, height: i32, color: rl.Color) @This() {
        const realColor = colorUtils.getRandomColor();
        return .{
            .id = id,
            .x = x,
            .y = y,
            .width = width,
            .height = height,
            .coverColor = color,
            .realColor = realColor,
        };
    }

    pub fn eqColor(self: @This(), other: @This()) bool {
        return self.realColor.r == other.realColor.r and self.realColor.g == other.realColor.g and self.realColor.b == other.realColor.b and self.realColor.a == other.realColor.a;
    }

    pub fn draw(self: @This()) void {
        if (!self.isActive) return;

        if (self.inRealColorMode) {
            rl.drawRectangle(self.x, self.y, self.width, self.height, self.realColor);
            return;
        }

        rl.drawRectangle(self.x, self.y, self.width, self.height, self.coverColor);
    }
};
