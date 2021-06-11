package isometric;

import flixel.util.FlxSort;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.FlxSprite;

class IsoWorld extends FlxTypedGroup<IsoObject> {
	private var tileWidth:Int;
	private var tileHeight:Int;

	// convenience floats since the half values are used frequently
	private var halfTileWidth:Float;
	private var halfTileHeight:Float;

	public function new(tileWidth:Int, tileHeight:Int) {
		super();
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		halfTileWidth = tileWidth * 0.5;
		halfTileHeight = tileHeight * 0.5;
	}

	// get the isometric coordinate given a standard cartesian (x,y)
	public function cartesianToIsometric(cartX:Float, cartY:Float):FlxPoint {
		return FlxPoint.get((cartX / halfTileWidth) - (((-cartY / halfTileHeight) + (cartX / halfTileWidth)) / 2.0),
			((-cartY / halfTileHeight) + (cartX / halfTileWidth)) / 2.0);
	}

	// get the world cartesian point from an isometric coordinate
	public function isometricToCartesian(isoX:Float, isoY:Float):FlxPoint {
		var p = FlxPoint.get((halfTileWidth * isoX) + (halfTileWidth * isoY), (-halfTileHeight * isoX) + (halfTileHeight * isoY));
		p.y = -p.y;
		return p;
	}

	public function getChildAtCartesianPosition(cartX:Float, cartY:Float):IsoObject {
		var p = cartesianToIsometric(cartX, cartY);
		var x = Math.floor(p.x);
		var y = Math.floor(p.y);
		var childX:Int = 0;
		var childY:Int = 0;
		for (child in this) {
			childX = Math.floor(child.isoX);
			childY = Math.floor(child.isoY);
			if (x == childX && y == childY) {
				return child;
			}
		}
		return null;
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);
		sortIso();
	}

	private function sortIso() {
		sort(byIso, FlxSort.ASCENDING);
	}

	public inline function byIso(order:Int, a:IsoObject, b:IsoObject):Int {
		return FlxSort.byValues(order, a.y - a.sprOffset.y + (a.elevation * tileHeight), b.y - b.sprOffset.y + (b.elevation * tileHeight));
	}
}
