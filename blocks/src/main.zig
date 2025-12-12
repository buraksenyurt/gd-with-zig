const rl = @import("raylib");

const MAX_BLOCKS: usize = 8 * 6;
const ROW_BLOCKS: usize = 8;
const COL_BLOCKS: usize = 6;
const BLOCK_WIDTH: i32 = 100;
const BLOCK_HEIGHT: i32 = 100;
pub fn main() !void {
    var game = Game{};
    game.loadBlocks();
    var blockPairIndex: usize = 0;

    rl.initWindow(800, 740, "Blocks Game in Zig with Raylib");
    defer rl.closeWindow();

    rl.setTargetFPS(60);
    const ferris = try rl.loadTexture("resources/ferris_00.png");
    defer rl.unloadTexture(ferris);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);

        rl.drawTexture(ferris, 10, 610, rl.Color.white);

        if (rl.isMouseButtonPressed(rl.MouseButton.left)) {
            if (game.playerAttempts == game.totalGuess) {
                if (game.blocks[game.blockPair[0].id].x == game.blocks[game.blockPair[1].id].x and
                    game.blocks[game.blockPair[0].id].y == game.blocks[game.blockPair[1].id].y)
                {
                    // Same block clicked twice, ignore
                    game.playerAttempts = 1;
                    game.blockPair[1] = undefined;
                    blockPairIndex = 1;
                    continue;
                }

                if (game.blockPair[0].eqColor(game.blockPair[1])) {
                    game.foundPairs = true;
                    game.totalBlocks -= 2;
                    game.blocks[game.blockPair[0].id].isActive = false;
                    game.blocks[game.blockPair[1].id].isActive = false;
                } else {
                    game.foundPairs = false;
                }
                game.blocks[game.blockPair[0].id].inRealColorMode = false;
                game.blocks[game.blockPair[1].id].inRealColorMode = false;
                blockPairIndex = 0;
                game.playerAttempts = 0;
                game.blockPair[0] = undefined;
                game.blockPair[1] = undefined;
            } else {
                const mouseX = rl.getMouseX();
                const mouseY = rl.getMouseY();

                for (0..game.blocks.len) |i| {
                    var block = &game.blocks[i];

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

        for (game.blocks) |block| {
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
    totalBlocks: usize = MAX_BLOCKS,
    totalAttempts: usize = 0,
    playerAttempts: usize = 0,
    foundPairs: bool = false,
    blockPair: [2]Block = undefined,
    blocks: [MAX_BLOCKS]Block = undefined,
    totalGuess: usize = 2,
    totalPairCount: usize = 0,

    pub fn loadBlocks(self: *@This()) void {
        var index: u32 = 0;
        for (0..ROW_BLOCKS) |i| {
            for (0..COL_BLOCKS) |j| {
                const x = @as(i32, @intCast(i));
                const y = @as(i32, @intCast(j));
                self.blocks[index] = Block.init(
                    index,
                    x * BLOCK_WIDTH,
                    y * BLOCK_HEIGHT,
                    BLOCK_WIDTH - 2,
                    BLOCK_HEIGHT - 2,
                    rl.Color.blue,
                );
                index += 1;
            }
        }
        self.calculateTotalPairs();
    }

    fn calculateTotalPairs(self: *@This()) void {
        //todo@buraksenyurt Find unique colors and calculate pairs count accordingly

        self.totalPairCount = MAX_BLOCKS / 2;
    }

    pub fn draw(self: @This()) void {
        const xPos = 150;
        const scoreText = rl.textFormat("Blocks:    %d(Pairs: %d)   Attempts: %d    Player Attempt: %d", .{
            self.totalBlocks,
            self.totalPairCount,
            self.totalAttempts,
            self.playerAttempts,
        });
        rl.drawText(scoreText, xPos, 620, 20, rl.Color.white);
        if (self.foundPairs) {
            rl.drawText("Last pair was a match!", xPos, 650, 20, rl.Color.green);
        } else {
            rl.drawText("Last pair was not a match.", xPos, 650, 20, rl.Color.red);
        }
        const color1 = self.blockPair[0].realColor;
        const color2 = self.blockPair[1].realColor;
        const rColorText = rl.textFormat("Color 1 %d,%d,%d,%d", .{ color1.r, color1.g, color1.b, color1.a });
        const lColorText = rl.textFormat("Color 2 %d,%d,%d,%d", .{ color2.r, color2.g, color2.b, color2.a });
        rl.drawText(rColorText, xPos, 680, 20, rl.Color.white);
        rl.drawText(lColorText, xPos, 700, 20, rl.Color.white);
    }
};
