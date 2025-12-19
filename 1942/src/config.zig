const rl = @import("raylib");

pub const Config = struct {
    pub const SCREEN_WIDTH: i32 = 600;
    pub const SCREEN_HEIGHT: i32 = 800;
    pub const FPS: i32 = 60;
    pub const TITLE_FONT_SIZE: i32 = 30;
    pub const PLAYER_SPEED: f32 = 350.0;
    pub const PLAYER_WIDTH: f32 = 96.0;
    pub const PLAYER_HEIGHT: f32 = 67.0;
    pub const BOT_WIDTH: f32 = 64.0;
    pub const BOT_HEIGHT: f32 = 64.0;
    pub const BOT_SPEED: f32 = 60.0;
    pub const MAX_BOTS: usize = 20;
    pub const F_ROW_COUNT: usize = 4;
    pub const F_COL_COUNT: usize = 5;
    pub const FORMATION_START_Y: f32 = -300.0;
    pub const BACKGROUND_COLOR = rl.Color{ .r = 190, .g = 136, .b = 113, .a = 100 };
    pub const MAX_BULLETS: usize = 5;
    pub const BULLET_SPEED: f32 = 250.0;
};
