package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import ui.FlxVirtualPad;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";

	var _pad:FlxVirtualPad;

	public function new(x:Float, y:Float,char:String)
	{
		var daStage = PlayState.curStage;
		var daBf:String = '';
		switch (char)
		{
			case 'bf-pixel':
				stageSuffix = '-pixel';
			default:
				daBf = 'bf';
		}
		if (char == "bf-pixel")
		{
			char = "bf-pixel-dead";
		}
		if (char == "bf-car")
		{
			char = "bf";
		}

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, char);
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');

		_pad = new FlxVirtualPad(NONE, A_B);
    	        _pad.alpha = 0.75;
    	        this.add(_pad);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var ACCEPT = _pad.buttonA.justPressed;
		var BACK = _pad.buttonB.justPressed;

		if (ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK || BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
						LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
