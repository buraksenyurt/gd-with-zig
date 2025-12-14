pub const Config = struct {
    pub const MAX_BLOCKS: usize = 8 * 6;
    pub const ROW_BLOCKS: usize = 8;
    pub const COL_BLOCKS: usize = 6;
    pub const BLOCK_WIDTH: i32 = 100;
    pub const BLOCK_HEIGHT: i32 = 100;

    pub const COLOR_NAMES = [_][]const u8{
        "violet",
        "dark_green",
        "beige",
        "brown",
        "orange",
        "magenta",
        "sky_blue",
        "lime",
        "yellow",
    };
};
