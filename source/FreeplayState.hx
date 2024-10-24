package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.util.FlxStringUtil;
import lime.utils.Assets;
import ui.FlxVirtualPad;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('backgrounds/SUSSUS AMOGUS'));

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	private var curChar:String = "unknown";

	var songColors:Array<FlxColor> = [
        0xFFca1f6f, // GF
        0xFFc885e5, // DAD
        0xFFf9a326, // SPOOKY
        0xFFceec75, // PICO
        0xFFec7aac, // MOM
        0xFFffffff, // PARENTS-CHRISTMAS
        0xFFffaa6f, // SENPAI
		0xFF4965FF, // DAVVE
		0xFF00B515, // MISTER BAMBI RETARD
		0xFF00FFFF


    ];

	private var iconArray:Array<HealthIcon> = [];

	var _pad:FlxVirtualPad;

	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			if (initSonglist[i].toLowerCase() == 'cheating')
			{
				FlxG.switchState(new VideoState('assets/videos/fortnite/fortniteballs.webm', new EndingState("unfunnyEnding",'freakyMenu'))); //YOU THINK YOU ARE SO CLEVER DON'T YOU? HAHA FUCK YOU
				songs.push(new SongMetadata("fuck you not really", 1, 'bambi-stupid'));
			}
			else
			{
				songs.push(new SongMetadata(initSonglist[i], 1, 'gf'));
			}
		}

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

			addWeek(['Bopeebo', 'Fresh', 'Dadbattle'], 1, ['dad']);
			addWeek(['Spookeez', 'South', 'Monster'], 2, ['spooky', 'spooky', 'monster']);
			addWeek(['Pico', 'Philly', 'Blammed'], 3, ['pico']);

			addWeek(['Satin-Panties', 'High', 'Milf'], 4, ['mom']);
			addWeek(['Cocoa', 'Eggnog', 'Winter-Horrorland'], 5, ['parents-christmas', 'parents-christmas', 'monster-christmas']);
			
			addWeek(['Senpai', 'Roses', 'Thorns'], 6, ['senpai', 'senpai', 'spirit']);
			addWeek(['House', 'Insanity', 'Furiosity'], 7, ['dave', 'dave', 'dave-angey']);

			if(StoryMenuState.weekUnlocked[8] || isDebug)
			{
				addWeek(['Bonus-Song'],7,['dave']);
				addWeek(['Blocked','Corn-Theft','Maze',], 8, ['bambi']);
				addWeek(['Supernovae', 'Glitch'], 8, ['bambi-stupid']);
			}
			if(StoryMenuState.weekUnlocked[9] || isDebug)	
			{
				addWeek(['Splitathon'],9,['the-duo']);
			}

		// LOAD MUSIC

		// LOAD CHARACTERS

		var randomNum:Int = FlxG.random.int(0, 6);
		switch(randomNum)
		{
			case 0:
				bg.loadGraphic(Paths.image('backgrounds/SUSSUS AMOGUS'));
			case 1:
				bg.loadGraphic(Paths.image('backgrounds/SwagnotrllyTheMod'));
			case 2:
				bg.loadGraphic(Paths.image('backgrounds/Olyantwo'));
			case 3:
				bg.loadGraphic(Paths.image('backgrounds/morie'));
			case 4:
				bg.loadGraphic(Paths.image('backgrounds/mantis'));
			case 5:
				bg.loadGraphic(Paths.image('backgrounds/mamakotomi'));
			case 6:
				bg.loadGraphic(Paths.image('backgrounds/T5mpler'));
		}
		bg.color = songColors[songs[curSelected].week];
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		_pad = new FlxVirtualPad(FULL, A_B);
		_pad.alpha = 0.65;
		this.add(_pad);

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		/*var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
                */

		var upP = _pad.buttonUp.justPressed;
		var downP = _pad.buttonDown.justPressed;
		var LEFT_P = _pad.buttonLeft.justPressed;
		var RIGHT_P = _pad.buttonRight.justPressed;
		var accepted = _pad.buttonA.justPressed;
		#if android
		var BACK = _pad.buttonB.justPressed || FlxG.android.justReleased.BACK;
		#else
		var BACK = _pad.buttonB.justPressed;
		#end

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if(songs[curSelected].week != 9)
		{
			if (LEFT_P)
				changeDiff(-1);
			if (RIGHT_P)
				changeDiff(1);
		}
		else
		{
			curDifficulty = 1;
			diffText.text = 'FINALE' + " - " + curChar.toUpperCase();
		}

		if (BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new CharacterSelectState());
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;
		if (songs[curSelected].week != 7)
		{
		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;
		}
		else
		{
			if (curDifficulty < 0)
				curDifficulty = 3;
			if (curDifficulty > 3)
				curDifficulty = 0;
		}
		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end
		curChar = Highscore.getChar(songs[curSelected].songName, curDifficulty);
		switch (curDifficulty)
		{
			case 0:
				diffText.text = "EASY" + " - " + curChar.toUpperCase();
			case 1:
				diffText.text = 'NORMAL' + " - " + curChar.toUpperCase();
			case 2:
				diffText.text = "HARD" + " - " + curChar.toUpperCase();
			case 3:
				diffText.text = "UNNERFED" + " - " + curChar.toUpperCase();
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
		curChar = Highscore.getChar(songs[curSelected].songName, curDifficulty);
		if (songs[curSelected].week != 7)
			{
			if (curDifficulty < 0)
				curDifficulty = 2;
			if (curDifficulty > 2)
				curDifficulty = 0;
			}
			switch (curDifficulty)
			{
				case 0:
					diffText.text = "EASY" + " - " + curChar.toUpperCase();
				case 1:
					diffText.text = 'NORMAL' + " - " + curChar.toUpperCase();
				case 2:
					diffText.text = "HARD" + " - " + curChar.toUpperCase();
				case 3:
					diffText.text = "UNNERFED" + " - " + curChar.toUpperCase();
			}
		// selector.y = (70 * curSelected) + 30;
		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);

		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
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
		FlxTween.color(bg, 0.1, bg.color, songColors[songs[curSelected].week]);
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
