class Main {

	static public var pgame:phaser.Game;

	static public var game_scene:GameScene;

	static function main() {

		var scene_config:phaser.types.scenes.SettingsConfig = {
            key: 'main_menu'
        };

		game_scene = new GameScene(scene_config);

		var config:phaser.types.core.GameConfig = {
            type: Phaser.AUTO,
			roundPixels: true,
            pixelArt: true,
			width: '100%',
			height: '100%',
            scale: {
                mode: RESIZE,
                autoCenter: CENTER_BOTH,
                parent: 'game_canvas_wrapper',
                width: '100%',
                height: '100%'
            },
            parent: 'game_canvas_wrapper',
            backgroundColor: '#000',
            physics: {
                // this fails because of some haxe @:native code gen bug
                //default_: 'arcade',
                "default": 'arcade',
                arcade: {
                    gravity: {
                        y: 0
                    },
                    debug: true
                }
            },

            scene: game_scene,
        };

		var scene_config:phaser.types.scenes.SettingsConfig = {
            key: 'main_menu'
        };

		pgame = new phaser.Game(config);

		
	}
}
