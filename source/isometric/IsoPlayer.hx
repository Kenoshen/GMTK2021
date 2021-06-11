package isometric;

import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class IsoPlayer extends IsoObject {
	var speed:Float = 0.03;
	var playerNum = 0;

	public function new(world:IsoWorld) {
		super(world);
		elevation = 1.0;
		makeGraphic(20, 20, FlxColor.WHITE);
		color = FlxColor.BLUE;
	}

	override public function update(delta:Float) {
		super.update(delta);

		var inputDir = InputCalcuator.getInputCardinal(playerNum);
		if (inputDir != NONE) {
			inputDir.asVector(isoVelocity).scale(speed);
			isoVelocity.y *= -1;
		} else {
			isoVelocity.set();
		}

		if (SimpleController.just_pressed(Button.A, playerNum)) {
			color = color ^ 0xFFFFFF;
		}
	}
}
