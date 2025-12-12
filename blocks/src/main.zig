const rl = @import("raylib");
pub fn main() !void {
    const blockSize = .{ 16, 12 };
    const totalBlocks = blockSize[0] * blockSize[1];
    var game = Game.init();
    game.totalBlocks = totalBlocks;
    const totalGuess: usize = 2;
    var blocks: [totalBlocks]Block = undefined;
    var index: u32 = 0;

    var blockPairIndex: usize = 0;

    for (0..blockSize[0]) |i| {
        for (0..blockSize[1]) |j| {
            const x = @as(i32, @intCast(i));
            const y = @as(i32, @intCast(j));
            blocks[index] = Block.init(index, x * 50, y * 50, 48, 48, rl.Color.blue);
            index += 1;
        }
    }

    rl.initWindow(800, 800, "Blocks Game in Zig with Raylib");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);

        if (rl.isMouseButtonPressed(rl.MouseButton.left)) {
            if (game.playerAttempts == totalGuess) {
                if (isColorEqual(game.blockPair[0].realColor, game.blockPair[1].realColor)) {
                    game.foundPairs = true;
                    blocks[game.blockPair[0].id].isActive = false;
                    blocks[game.blockPair[1].id].isActive = false;
                } else {
                    game.foundPairs = false;
                }
                game.blockPair[0].inRealColorMode = false;
                game.blockPair[1].inRealColorMode = false;
                blockPairIndex = 0;
                game.playerAttempts = 0;
                game.blockPair[0] = undefined;
                game.blockPair[1] = undefined;
            } else {
                const mouseX = rl.getMouseX();
                const mouseY = rl.getMouseY();

                for (0..blocks.len) |i| {
                    var block = &blocks[i];
                    if (mouseX >= block.x and mouseX <= block.x + block.width and
                        mouseY >= block.y and mouseY <= block.y + block.height)
                    {
                        game.totalAttempts += 1;
                        game.playerAttempts += 1;
                        game.blockPair[blockPairIndex] = block.*;
                        blockPairIndex += 1;
                        block.inRealColorMode = true;
                    }
                }
            }
        }

        for (blocks) |block| {
            block.draw();
        }

        game.draw();
    }
}

const Block = struct {
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
        const realColor = getRandomColor();
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

    pub fn draw(self: @This()) void {
        if (!self.isActive) return;

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

const Game = struct {
    totalBlocks: usize,
    totalAttempts: usize,
    playerAttempts: usize,
    foundPairs: bool = false,
    blockPair: [2]Block = undefined,

    pub fn init() @This() {
        return .{ .totalBlocks = 0, .totalAttempts = 0, .playerAttempts = 0, .foundPairs = false };
    }

    pub fn draw(self: @This()) void {
        const scoreText = rl.textFormat("Blocks: %d   Attempts: %d Current Attempts: %d", .{
            self.totalBlocks,
            self.totalAttempts,
            self.playerAttempts,
        });
        rl.drawText(scoreText, 10, 600, 20, rl.Color.white);
        if (self.foundPairs) {
            rl.drawText("Last pair was a match!", 10, 620, 20, rl.Color.green);
        } else {
            rl.drawText("Last pair was not a match.", 10, 620, 20, rl.Color.red);
        }
        const color1 = self.blockPair[0].realColor;
        const color2 = self.blockPair[1].realColor;
        const rColorText = rl.textFormat("Color 1 %d,%d,%d,%d", .{ color1.r, color1.g, color1.b, color1.a });
        const lColorText = rl.textFormat("Color 2 %d,%d,%d,%d", .{ color2.r, color2.g, color2.b, color2.a });
        rl.drawText(rColorText, 10, 650, 20, rl.Color.white);
        rl.drawText(lColorText, 10, 670, 20, rl.Color.white);
    }
};

fn isColorEqual(color1: rl.Color, color2: rl.Color) bool {
    return color1.r == color2.r and color1.g == color2.g and color1.b == color2.b and color1.a == color2.a;
}
