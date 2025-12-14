const rl = @import("raylib");
const std = @import("std");
const config = @import("config.zig").Config;

pub const ColorUtils = struct {
    pub fn getColorByName(name: []const u8) rl.Color {
        if (std.mem.eql(u8, name, "violet")) return rl.Color.violet.alpha(0.9);
        if (std.mem.eql(u8, name, "dark_green")) return rl.Color.dark_green.alpha(0.9);
        if (std.mem.eql(u8, name, "beige")) return rl.Color.beige.alpha(0.9);
        if (std.mem.eql(u8, name, "brown")) return rl.Color.brown.alpha(0.9);
        if (std.mem.eql(u8, name, "orange")) return rl.Color.orange.alpha(0.9);
        if (std.mem.eql(u8, name, "magenta")) return rl.Color.magenta.alpha(0.9);
        if (std.mem.eql(u8, name, "sky_blue")) return rl.Color.sky_blue.alpha(0.9);
        if (std.mem.eql(u8, name, "lime")) return rl.Color.lime.alpha(0.9);
        if (std.mem.eql(u8, name, "yellow")) return rl.Color.yellow.alpha(0.9);
        return rl.Color.white;
    }

    pub fn getRandomColor() rl.Color {
        const randomIndex: usize = @intCast(rl.getRandomValue(0, config.COLOR_NAMES.len - 1));
        const color = config.COLOR_NAMES[randomIndex];
        return getColorByName(color);
    }
};
