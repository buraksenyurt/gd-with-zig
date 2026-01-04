const TextBlock = @import("textBlock.zig").TextBlock;
const TextAlignment = @import("textBlock.zig").TextAlignment;
const rl = @import("raylib");
const config = @import("config.zig").Config;

const HORIZONTAL_CENTER = @as(f32, config.SCREEN_WIDTH) / 2.0;
const VERTICAL_CENTER = @as(f32, config.SCREEN_HEIGHT) / 2.0;

pub const gameOverText = TextBlock{
    .text = "Game Over! Press R to Restart",
    .position = rl.Vector2{
        .x = HORIZONTAL_CENTER,
        .y = VERTICAL_CENTER - @as(f32, config.TITLE_FONT_SIZE * 2),
    },
    .fontSize = config.TITLE_FONT_SIZE,
    .color = rl.Color.white,
};

pub const playerWinText = TextBlock{
    .text = "You Win with %d points.!\nPress R to Restart",
    .position = rl.Vector2{
        .x = HORIZONTAL_CENTER,
        .y = VERTICAL_CENTER - @as(f32, config.TITLE_FONT_SIZE * 2),
    },
    .fontSize = config.TITLE_FONT_SIZE,
    .color = rl.Color.white,
};

pub const hudText = TextBlock{
    .text = "Score: %d Remaining: %d Bullets: %d Elapsed Time: %d s",
    .position = rl.Vector2{
        .x = 10.0,
        .y = @as(f32, config.AREA_HEIGHT) + 10.0,
    },
    .fontSize = config.HUD_FONT_SIZE,
    .color = config.HUD_FONT_COLOR,
};
