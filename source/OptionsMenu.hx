package;

import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import ui.FlxVirtualPad;
import options.CustomControlsState;

class OptionsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	var _pad:FlxVirtualPad;

	var UP_P:Bool;
	var DOWN_P:Bool;
	var LEFT_R:Bool;
	var RIGHT_R:Bool;
	var CONTROLS:Bool;
	var BACK:Bool;
	var ACCEPT:Bool;
	//var CONTROLS:Bool;
	
	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('backgrounds/SUSSUS AMOGUS'));
		controlsStrings = CoolUtil.coolStringFile((FlxG.save.data.dfjk ? 'DFJK' : 'WASD') + "\n" + (FlxG.save.data.newInput ? "New input" : "Old Input") + "\n" + (FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll') + "\nAccuracy " + (FlxG.save.data.accuracyDisplay ? "off" : "on") + "\n" + (FlxG.save.data.eyesores ? 'Eyesores Enabled' : 'Eyesores Disabled') + "\n" + (FlxG.save.data.donoteclick ? "Hitsounds On" : "Hitsounds Off"));
		
		trace(controlsStrings);

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		var randomNum:Int = FlxG.random.int(0, 6);
		switch(randomNum)
		{
			case 0:
				menuBG.loadGraphic(Paths.image('backgrounds/SUSSUS AMOGUS'));
			case 1:
				menuBG.loadGraphic(Paths.image('backgrounds/SwagnotrllyTheMod'));
			case 2:
				menuBG.loadGraphic(Paths.image('backgrounds/Olyantwo'));
			case 3:
				menuBG.loadGraphic(Paths.image('backgrounds/morie'));
			case 4:
				menuBG.loadGraphic(Paths.image('backgrounds/mantis'));
			case 5:
				menuBG.loadGraphic(Paths.image('backgrounds/mamakotomi'));
			case 6:
				menuBG.loadGraphic(Paths.image('backgrounds/T5mpler'));
		}
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}


		versionShit = new FlxText(5, FlxG.height - 18, 0, "Offset (Left, Right): " + FlxG.save.data.offset, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		_pad = new FlxVirtualPad(FULL, A_B_C);
		_pad.alpha = 0.75;
		this.add(_pad);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		UP_P = _pad.buttonUp.justReleased;
		DOWN_P = _pad.buttonDown.justReleased;
		RIGHT_R = _pad.buttonRight.justPressed;
		LEFT_R = _pad.buttonLeft.justPressed;

		CONTROLS = _pad.buttonC.justPressed;

		#if android
		BACK = _pad.buttonB.justPressed || FlxG.android.justReleased.BACK;
		#else
		BACK = _pad.buttonB.justPressed;
		#end

		//CONTROLS = _pad.buttonC.justPressed;
			
		ACCEPT = _pad.buttonA.justReleased;

			if (BACK)
				FlxG.switchState(new MainMenuState());
			if (UP_P)
				changeSelection(-1);
			if (DOWN_P)
				changeSelection(1);
			
			if (RIGHT_R)
			{
				FlxG.save.data.offset++;
				versionShit.text = "Offset (Left, Right): " + FlxG.save.data.offset;
			}

			if (LEFT_R)
				{
					FlxG.save.data.offset--;
					versionShit.text = "Offset (Left, Right): " + FlxG.save.data.offset;
				}

		        if (CONTROLS)
			{
				FlxG.switchState(new CustomControlsState());
			}

			if (ACCEPT)
			{
				grpControls.remove(grpControls.members[curSelected]);
				switch(curSelected)
				{
					case 0:
						FlxG.save.data.dfjk = !FlxG.save.data.dfjk;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.dfjk ? 'DFJK' : 'WASD'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected;
						grpControls.add(ctrl);
						if (FlxG.save.data.dfjk)
							controls.setKeyboardScheme(KeyboardScheme.Solo, true);
						else
							controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);
						
					case 1:
						FlxG.save.data.newInput = !FlxG.save.data.newInput;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.newInput ? "New input" : "Old Input"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 1;
						grpControls.add(ctrl);
					case 2:
						FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 2;
						grpControls.add(ctrl);
					case 3:
						FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Accuracy " + (FlxG.save.data.accuracyDisplay ? "off" : "on"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 3;
						grpControls.add(ctrl);
					case 4:
						FlxG.save.data.eyesores = !FlxG.save.data.eyesores;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.eyesores ? 'Eyesores Enabled' : 'Eyesores Disabled'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 4;
						grpControls.add(ctrl);
					case 5:
						FlxG.save.data.donoteclick = !FlxG.save.data.donoteclick;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.donoteclick ? "Hitsounds On" : "Hitsounds Off"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 5;
						grpControls.add(ctrl);
				}
			}
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end
		
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
