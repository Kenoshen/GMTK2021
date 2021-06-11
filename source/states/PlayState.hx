package states;

import isometric.IsoObject;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.group.FlxGroup;
import flixel.math.FlxRandom;
import flixel.graphics.frames.FlxTileFrames;
import flixel.math.FlxPoint;
import openfl.display.BitmapData;
import openfl.Assets;
import flixel.graphics.atlas.FlxNode;
import flixel.graphics.atlas.FlxAtlas;
import flixel.addons.transition.FlxTransitionableState;
import signals.Lifecycle;
import entities.Player;
import isometric.IsoWorld;
import isometric.IsoPlayer;
import flixel.FlxSprite;
import flixel.FlxG;

using extensions.FlxStateExt;

class PlayState extends FlxTransitionableState {
	var player:IsoPlayer;
	var isoWorld:IsoWorld;
	var tileFrames:FlxTileFrames;
	var rnd:FlxRandom;
	var previousHover:IsoObject;

	override public function create() {
		super.create();
		Lifecycle.startup.dispatch();

		FlxG.camera.pixelPerfectRender = true;

		var atlas:FlxAtlas = new FlxAtlas("myAtlas");

		// and add nodes (images) to it
		var tilesNode:FlxNode = createNodeAndDisposeBitmap("assets/images/isometric/tiles.png", atlas);
		tileFrames = tilesNode.getTileFrames(FlxPoint.get(100, 80));

		rnd = new FlxRandom();

		isoWorld = new IsoWorld(100, 50);
		add(isoWorld);
		gen();

		player = new IsoPlayer(isoWorld);
		camera.focusOn(FlxPoint.get());
	}

	function gen() {
		for (s in isoWorld) {
			s.kill();
		}
		isoWorld.clear();
		for (x in 0...10) {
			for (y in 0...10) {
				var o = new IsoObject(isoWorld, x - 5, y - 5, 0, -30);
				o.frame = tileFrames.frames[rnd.int(0, tileFrames.frames.length - 1)];
			}
		}
	}

	/**
	 * Helper method for getting FlxNodes for images, but with image disposing (for memory savings)
	 * @param	source	path to the image
	 * @param	atlas	atlas to load image onto
	 * @return	created FlxNode object for image
	 */
	function createNodeAndDisposeBitmap(source:String, atlas:FlxAtlas):FlxNode {
		var bitmap:BitmapData = Assets.getBitmapData(source);
		var node:FlxNode = atlas.addNode(bitmap, source);
		Assets.cache.removeBitmapData(source);
		bitmap.dispose();
		return node;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE) {
			gen();
		}

		var mousePos = FlxG.mouse.getPosition();
		var hover = isoWorld.getChildAtCartesianPosition(mousePos.x, mousePos.y);
		if (hover != null) {
			if (previousHover != hover) {
				if (previousHover != null) {
					previousHover.visible = true;
				}
				previousHover = hover;
				trace(hover.isoX, hover.isoY);
			}
			hover.visible = false;
		}
	}

	override public function onFocusLost() {
		super.onFocusLost();
		this.handleFocusLost();
	}

	override public function onFocus() {
		super.onFocus();
		this.handleFocus();
	}
}
