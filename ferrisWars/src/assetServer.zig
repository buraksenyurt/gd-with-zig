const rl = @import("raylib");

pub const AssetServer = struct {
    player: rl.Texture2D = undefined,
    bots: [3]rl.Texture2D = undefined,
    bullet: rl.Texture2D = undefined,
    botBullet: rl.Texture2D = undefined,
    mine: rl.Texture2D = undefined,
    cover: rl.Texture2D = undefined,
    explosionSheet: rl.Texture2D = undefined,
    microControllerAnimation: rl.Texture2D = undefined,
    jumperAnimation: rl.Texture2D = undefined,
    winningSound: rl.Sound = undefined,
    losingSound: rl.Sound = undefined,
    explosionSound: rl.Sound = undefined,
    levelMusic: rl.Sound = undefined,
    shootingSound: rl.Sound = undefined,

    pub fn load() !@This() {
        var assets = @This(){};

        // Textures
        assets.player = try rl.loadTexture("resources/asset/hero.png");
        assets.bots[0] = try rl.loadTexture("resources/asset/bot_1.png");
        assets.bots[1] = try rl.loadTexture("resources/asset/bot_2.png");
        assets.bots[2] = try rl.loadTexture("resources/asset/bot_3.png");
        assets.bullet = try rl.loadTexture("resources/asset/rocket.png");
        assets.botBullet = try rl.loadTexture("resources/asset/botBullet.png");
        assets.mine = try rl.loadTexture("resources/asset/mine.png");
        assets.cover = try rl.loadTexture("resources/asset/cover.png");

        // Sprite Sheets
        assets.explosionSheet = try rl.loadTexture("resources/asset/explosion_spriteSheet.png");
        assets.microControllerAnimation = try rl.loadTexture("resources/asset/micro_spriteSheet.png");
        assets.jumperAnimation = try rl.loadTexture("resources/asset/jumper_spriteSheet.png");
        // Sounds
        assets.winningSound = try rl.loadSound("resources/audio/winning.wav");
        assets.losingSound = try rl.loadSound("resources/audio/losing.wav");
        assets.explosionSound = try rl.loadSound("resources/audio/explosion.wav");
        assets.levelMusic = try rl.loadSound("resources/audio/levelMusic.wav");
        assets.shootingSound = try rl.loadSound("resources/audio/shooting.wav");

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
        rl.unloadTexture(self.explosionSheet);
        rl.unloadTexture(self.microControllerAnimation);
        rl.unloadTexture(self.jumperAnimation);

        rl.unloadSound(self.winningSound);
        rl.unloadSound(self.losingSound);
        rl.unloadSound(self.explosionSound);
        rl.unloadSound(self.levelMusic);
        rl.unloadSound(self.shootingSound);
    }
};
