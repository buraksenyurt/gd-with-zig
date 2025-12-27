const rl = @import("raylib");

pub const AssetServer = struct {
    player: rl.Texture2D = undefined,
    bots: [3]rl.Texture2D = undefined,
    bullet: rl.Texture2D = undefined,
    botBullet: rl.Texture2D = undefined,
    mine: rl.Texture2D = undefined,
    cover: rl.Texture2D = undefined,

    pub fn load() !@This() {
        var assets = @This(){};
        assets.player = try rl.loadTexture("resources/hero.png");
        assets.bots[0] = try rl.loadTexture("resources/bot_1.png");
        assets.bots[1] = try rl.loadTexture("resources/bot_2.png");
        assets.bots[2] = try rl.loadTexture("resources/bot_3.png");
        assets.bullet = try rl.loadTexture("resources/rocket.png");
        assets.botBullet = try rl.loadTexture("resources/botBullet.png");
        assets.mine = try rl.loadTexture("resources/mine.png");
        assets.cover = try rl.loadTexture("resources/cover.png");

        return assets;
    }

    pub fn unload(self: @This()) void {
        rl.unloadTexture(self.player);
        for (self.bots[0..]) |bot| {
            rl.unloadTexture(bot);
        }
        rl.unloadTexture(self.bullet);
        rl.unloadTexture(self.mine);
        rl.unloadTexture(self.cover);
        rl.unloadTexture(self.botBullet);
    }
};
