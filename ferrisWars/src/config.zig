const rl = @import("raylib");

pub const Config = struct {
    pub const SCREEN_WIDTH: i32 = 600;
    pub const SCREEN_HEIGHT: i32 = 800;
    pub const AREA_HEIGHT: i32 = 750;
    pub const FPS: i32 = 60;
    pub const TITLE_FONT_SIZE: i32 = 30;
    pub const PLAYER_SPEED: f32 = 250.0;
    pub const PLAYER_WIDTH: f32 = 96.0;
    pub const PLAYER_HEIGHT: f32 = 67.0;
    pub const BOT_WIDTH: f32 = 64.0;
    pub const BOT_HEIGHT: f32 = 64.0;
    pub const BOT_SPEED: f32 = 60.0;
    pub const MAX_BOT_COUNT: usize = 20;
    pub const F_ROW_COUNT: usize = 4;
    pub const F_COL_COUNT: usize = 5;
    pub const FORMATION_START_Y: f32 = -300.0;
    pub const BACKGROUND_COLOR = rl.Color{ .r = 190, .g = 136, .b = 113, .a = 100 };
    pub const HUD_BACKGROUND_COLOR = rl.Color{ .r = 50, .g = 50, .b = 50, .a = 255 };
    pub const MAX_BULLET_COUNT: usize = 5;
    pub const BULLET_SPEED: f32 = 300.0;
    pub const BULLET_WIDTH: f32 = 15.0;
    pub const BULLET_HEIGHT: f32 = 32.0;
    pub const BULLET_COOLDOWN: f32 = 0.3;
    pub const MAX_MINE_COUNT: usize = 4;
    pub const MINE_WIDTH: f32 = 36.0;
    pub const MINE_HEIGHT: f32 = 36.0;
};
