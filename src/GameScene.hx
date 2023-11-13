class GameScene extends phaser.Scene {

    public var width = 100;
    public var height = 100;
    public var tile_size = 32;

    public var player:phaser.physics.arcade.Sprite;

    var keyw:phaser.input.keyboard.Key;
    var keyd:phaser.input.keyboard.Key;
    var keys:phaser.input.keyboard.Key;
    var keya:phaser.input.keyboard.Key;

    public function new(?config:phaser.types.scenes.SettingsConfig) {
        super(config);
    }

    function init() {

    }

    function preload() {
        this.load.atlas('terrain', 'terrain.png', 'terrain.json');
        this.load.image('player', 'player.png');
    }

    function create() {
        var mapdata = new phaser.tilemaps.MapData({
            width: width,
            height: height,
            tileWidth: tile_size,
            tileHeight: tile_size
        });

        var tilemap = new phaser.tilemaps.Tilemap(this, mapdata);

        // load tileset
        var tiles = tilemap.addTilesetImage('terrain', null, tile_size, tile_size);

        // base layer will contain the base tiles
        var base_layer = tilemap.createBlankLayer('terrain_base_layer', tiles);

        var terrain_texture = this.textures.get('terrain');
        var frames_names = terrain_texture.getFrameNames();
        trace(frames_names);

        var frames = ['grass', 'grass2', 'grass3', 'grass4', 'grass5', 'dirt', 'water'];
        for (y in 0...height) {
            for (x in 0...width) {
                var r = phaser.Math_.RND.pick(frames);
                base_layer.putTileAt(frames_names.indexOf(r), x, y);
            }
        }

        this.cameras.main.setBounds(0, 0, tile_size * width, tile_size * height);

        this.player = this.physics.add.sprite(100, 100, 'player');
        this.player.setDepth(1);
        this.cameras.main.startFollow(player, true);

        this.keyw = this.input.keyboard.addKey(phaser.input.keyboard.KeyCodes.W);
        this.keya = this.input.keyboard.addKey(phaser.input.keyboard.KeyCodes.A);
        this.keys = this.input.keyboard.addKey(phaser.input.keyboard.KeyCodes.S);
        this.keyd = this.input.keyboard.addKey(phaser.input.keyboard.KeyCodes.D);

        // add edges to a render texture

        var rt = this.add.renderTexture(0, 0, width * tile_size, height * tile_size);
        rt.setOrigin(0, 0);
        rt.setDepth(0);

        // add edge tiles to 'c' tiles
        var c = 5000;
        var dirt_edges = ['dirt_top', 'dirt_right', 'dirt_bottom', 'dirt_left', 'dirt_bottom_left', 'dirt_bottom_right', 'dirt_top_left', 'dirt_top_right'];
        var texture = this.textures.get('terrain');

        for (i in 0...c) {
            var rx = Math.floor(phaser.Math_.Between(0, width - 1));
            var ry = Math.floor(phaser.Math_.Between(0, height - 1));

            var tile = tilemap.getTileAt(rx, ry);

            // choose random number of edges to add
            var e = Math.floor(phaser.Math_.Between(1, 4));

            var used_edges:Array<String> = [];
            for (j in 0...e) {
                var edge = phaser.Math_.RND.pick(dirt_edges);
                while (used_edges.indexOf(edge) >= 0) {
                    edge = phaser.Math_.RND.pick(dirt_edges);
                }
                used_edges.push(edge);
                
                var frame = texture.get(edge);
                rt.draw(frame, tile.pixelX, tile.pixelY);
            }
        }

    }

    override function update(time:Float, delta:Float) {
        if (keyw.isDown) {
            //player.setY(player.y - 2);
            player.setVelocityY(-400);
        }
        else if (keyd.isDown) {
            //player.setX(player.x + 2);
            player.setVelocityX(400);
        }
        else if (keys.isDown) {
            //player.setY(player.y + 2);
            player.setVelocityY(400);
        }
        else if (keya.isDown) {
            //player.setX(player.x - 2);
            player.setVelocityX(-400);
        }
        else {
            player.setVelocity(0);
            player.setPosition(Math.floor(player.x), Math.floor(player.y));
        }

    }
}