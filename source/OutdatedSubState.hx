package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import ui.FlxVirtualPad;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";

	var _pad:FlxVirtualPad;

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Hello! \nThis mod utilizes shaders that may be of disturbance to some. \nIf you wish to disable these, \nturn off the Eyesores option in the options menu. \n Also, Supernovae and Glitch are not meant to be taken seriously and are not composed by me. \n Supernovae is by ArchWk, and Glitch is by The Boneyard. \nPress Enter to continue.",
			32);
		txt.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);

		_pad = new FlxVirtualPad(NONE, A);
         	_pad.alpha = 0.75;
    	        this.add(_pad);
	}

	override function update(elapsed:Float)
	{
		var PAUSE = _pad.buttonA.justPressed;
		
		if (PAUSE)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
