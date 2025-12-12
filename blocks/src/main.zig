const rl = @import("raylib");
pub fn main() !void {
    rl.initWindow(800, 600, "Blocks Game in Zig with Raylib");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    var blocks: [16 * 12]Block = undefined;
    var index: usize = 0;

    for (0..16) |i| {
        for (0..12) |j| {
            const x = @as(i32, @intCast(i));
            const y = @as(i32, @intCast(j));
            blocks[index] = Block.init(x * 50, y * 50, 48, 48, rl.Color.blue);
            blocks[index].draw();
            index += 1;
        }
    }

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);

        for (blocks) |block| {
            block.draw();
        }

        if (rl.isMouseButtonPressed(rl.MouseButton.left)) {
            const mouseX = rl.getMouseX();
            const mouseY = rl.getMouseY();
            for (0..blocks.len) |i| {
                var block = &blocks[i];
                if (mouseX >= block.x and mouseX <= block.x + block.width and
                    mouseY >= block.y and mouseY <= block.y + block.height)
                {
                    block.inRealColorMode = true;
                }
            }
        }
    }
}

const Block = struct {
    x: i32,
    y: i32,
    width: i32,
    height: i32,
    coverColor: rl.Color,
    realColor: rl.Color,
    inRealColorMode: bool = false,

    pub fn init(x: i32, y: i32, width: i32, height: i32, color: rl.Color) @This() {
        const realColor = getRandomColor();
        return .{
            .x = x,
            .y = y,
            .width = width,
            .height = height,
            .coverColor = color,
            .realColor = realColor,
        };
    }

    pub fn draw(self: @This()) void {
        if (self.inRealColorMode) {
            rl.drawRectangle(self.x, self.y, self.width, self.height, self.realColor);
            return;
        }
        rl.drawRectangle(self.x, self.y, self.width, self.height, self.coverColor);
    }
};

fn getRandomColor() rl.Color {
    const colors = [_]rl.Color{
        rl.Color.violet.alpha(0.9),
        rl.Color.dark_green.alpha(0.9),
        rl.Color.beige.alpha(0.9),
        rl.Color.brown.alpha(0.9),
        rl.Color.orange.alpha(0.9),
        rl.Color.magenta.alpha(0.9),
        rl.Color.sky_blue.alpha(0.9),
        rl.Color.lime.alpha(0.9),
        rl.Color.yellow.alpha(0.9),
    };
    const randomIndex: usize = @intCast(rl.getRandomValue(0, colors.len - 1));
    return colors[randomIndex];
}
