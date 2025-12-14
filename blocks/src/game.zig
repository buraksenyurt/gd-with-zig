const config = @import("config.zig").Config;
const Block = @import("block.zig").Block;
const rl = @import("raylib");
const std = @import("std");
const colorUtils = @import("color.zig").ColorUtils;

pub const GameState = enum {
    Initial,
    Playing,
    Won,
};

pub const Game = struct {
    totalBlocks: usize = config.MAX_BLOCKS,
    totalAttempts: usize = 0,
    playerAttempts: usize = 0,
    foundPairs: bool = false,
    blockPair: [2]Block = undefined,
    blockPairIndex: usize = 0,
    blocks: [config.MAX_BLOCKS]Block = undefined,
    totalGuess: usize = 2,
    totalPairCount: usize = 0,
    foundedBlocksCount: usize = 0,
    state: GameState = GameState.Initial,

    pub fn init(self: *@This()) void {
        var index: u32 = 0;
        for (0..config.ROW_BLOCKS) |i| {
            for (0..config.COL_BLOCKS) |j| {
                const x = @as(i32, @intCast(i));
                const y = @as(i32, @intCast(j));
                self.blocks[index] = Block.init(
                    index,
                    x * config.BLOCK_WIDTH,
                    y * config.BLOCK_HEIGHT,
                    config.BLOCK_WIDTH - 2,
                    config.BLOCK_HEIGHT - 2,
                    rl.Color.blue,
                );
                index += 1;
            }
        }
        self.calculateTotalPairs();
        self.state = GameState.Playing;
    }

    fn calculateTotalPairs(self: *@This()) void {
        self.totalPairCount = 0;

        for (config.COLOR_NAMES) |colorName| {
            const targetColor = colorUtils.getColorByName(colorName);
            var count: usize = 0;

            for (self.blocks) |block| {
                if (std.meta.eql(block.realColor, targetColor)) {
                    count += 1;
                }
            }

            self.totalPairCount += count / 2;
        }
    }

    pub fn Update(self: *@This()) void {
        if (self.foundedBlocksCount == self.totalPairCount * 2) {
            std.log.info("MISSION COMPLETED", .{});
            rl.drawText("MISSION COMPLETED", 300, 350, 40, rl.Color.green);
            self.state = GameState.Won;
            return;
        }

        self.state = GameState.Playing;

        if (rl.isMouseButtonPressed(rl.MouseButton.left)) {
            if (self.playerAttempts == self.totalGuess) {
                if (self.blocks[self.blockPair[0].id].x == self.blocks[self.blockPair[1].id].x and
                    self.blocks[self.blockPair[0].id].y == self.blocks[self.blockPair[1].id].y)
                {
                    self.playerAttempts = 1;
                    self.blockPair[1] = undefined;
                    self.blockPairIndex = 1;
                    return;
                }

                if (self.blockPair[0].eqColor(self.blockPair[1])) {
                    self.foundPairs = true;
                    self.totalBlocks -= 2;
                    self.foundedBlocksCount += 2;
                    self.blocks[self.blockPair[0].id].isActive = false;
                    self.blocks[self.blockPair[1].id].isActive = false;
                } else {
                    self.foundPairs = false;
                }
                self.blocks[self.blockPair[0].id].inRealColorMode = false;
                self.blocks[self.blockPair[1].id].inRealColorMode = false;
                self.blockPairIndex = 0;
                self.playerAttempts = 0;
                self.blockPair[0] = undefined;
                self.blockPair[1] = undefined;
            } else {
                const mouseX = rl.getMouseX();
                const mouseY = rl.getMouseY();

                for (0..self.blocks.len) |i| {
                    var block = &self.blocks[i];

                    if (mouseX >= block.x and mouseX <= block.x + block.width and
                        mouseY >= block.y and mouseY <= block.y + block.height)
                    {
                        self.totalAttempts += 1;
                        self.playerAttempts += 1;
                        self.blockPair[self.blockPairIndex] = block.*;
                        self.blockPairIndex += 1;
                        block.inRealColorMode = true;
                    }
                }
            }
        }
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
