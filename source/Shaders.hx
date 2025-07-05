package;

import flixel.system.FlxAssets.FlxShader;

class VisualEffects
{
}

// === GLITCH EFFECT =======================================================
class GlitchEffect
{
	public var shader(default, null):GlitchShader = new GlitchShader();

	public var waveSpeed(default, set):Float = 0;
	public var waveFrequency(default, set):Float = 0;
	public var waveAmplitude(default, set):Float = 0;

	public function new():Void
	{
		shader.uTime.value = [0];
	}

	public function update(elapsed:Float):Void
	{
		shader.uTime.value[0] += elapsed;
	}

	function set_waveSpeed(v:Float):Float
	{
		waveSpeed = v;
		shader.uSpeed.value = [waveSpeed];
		return v;
	}

	function set_waveFrequency(v:Float):Float
	{
		waveFrequency = v;
		shader.uFrequency.value = [waveFrequency];
		return v;
	}

	function set_waveAmplitude(v:Float):Float
	{
		waveAmplitude = v;
		shader.uWaveAmplitude.value = [waveAmplitude];
		return v;
	}
}

class GlitchShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		#ifdef GL_ES
		precision mediump float;
		#endif

		uniform float uTime;
		uniform float uSpeed;
		uniform float uFrequency;
		uniform float uWaveAmplitude;

		float safeDiv(float num, float denom) {
			return num / max(denom, 0.0001);
		}

		vec2 sineWave(vec2 pt)
		{
			float offsetX = sin(pt.y * uFrequency + uTime * uSpeed) * (uWaveAmplitude * safeDiv(1.0, pt.x * pt.y));
			float offsetY = sin(pt.x * uFrequency - uTime * uSpeed) * (uWaveAmplitude * safeDiv(1.0, pt.y * pt.x));
			pt.x += offsetX;
			pt.y += offsetY;
			return pt;
		}

		void main()
		{
			vec2 uv = sineWave(openfl_TextureCoordv);
			gl_FragColor = texture2D(bitmap, uv);
		}
	')

	public function new() { super(); }
}

// === INVERT EFFECT =======================================================
class InvertColorsEffect
{
	public var shader(default, null):InvertShader = new InvertShader();
}

class InvertShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		#ifdef GL_ES
		precision mediump float;
		#endif

		void main()
		{
			vec4 color = texture2D(bitmap, openfl_TextureCoordv);
			gl_FragColor = vec4(1.0 - color.rgb, color.a);
		}
	')

	public function new() { super(); }
}

// === DISTORT BACKGROUND ==================================================
class DistortBGEffect
{
	public var shader(default, null):DistortBGShader = new DistortBGShader();

	public var waveSpeed(default, set):Float = 0;
	public var waveFrequency(default, set):Float = 0;
	public var waveAmplitude(default, set):Float = 0;

	public function new():Void
	{
		shader.uTime.value = [0];
	}

	public function update(elapsed:Float):Void
	{
		shader.uTime.value[0] += elapsed;
	}

	function set_waveSpeed(v:Float):Float
	{
		waveSpeed = v;
		shader.uSpeed.value = [waveSpeed];
		return v;
	}

	function set_waveFrequency(v:Float):Float
	{
		waveFrequency = v;
		shader.uFrequency.value = [waveFrequency];
		return v;
	}

	function set_waveAmplitude(v:Float):Float
	{
		waveAmplitude = v;
		shader.uWaveAmplitude.value = [waveAmplitude];
		return v;
	}
}

class DistortBGShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		#ifdef GL_ES
		precision mediump float;
		#endif

		uniform float uTime;
		uniform float uSpeed;
		uniform float uFrequency;
		uniform float uWaveAmplitude;

		float safeDiv(float num, float denom) {
			return num / max(denom, 0.0001);
		}

		vec2 sineWave(vec2 pt)
		{
			float offsetX = sin(pt.x * uFrequency + uTime * uSpeed) * (uWaveAmplitude * safeDiv(1.0, pt.x * pt.y));
			float offsetY = sin(pt.y * uFrequency - uTime * uSpeed) * uWaveAmplitude;
			pt.x += offsetX;
			pt.y += offsetY;
			return pt;
		}

		vec4 makeBlack(vec4 pt)
		{
			return vec4(0.0, 0.0, 0.0, pt.a);
		}

		void main()
		{
			vec2 uv = sineWave(openfl_TextureCoordv);
			gl_FragColor = makeBlack(texture2D(bitmap, uv)) + texture2D(bitmap, openfl_TextureCoordv);
		}
	')

	public function new() { super(); }
}

// === PULSE EFFECT ========================================================
class PulseEffect
{
	public var shader(default, null):PulseShader = new PulseShader();

	public var waveSpeed(default, set):Float = 0;
	public var waveFrequency(default, set):Float = 0;
	public var waveAmplitude(default, set):Float = 0;
	public var Enabled(default, set):Bool = false;

	public function new():Void
	{
		shader.uTime.value = [0];
		shader.uampmul.value = [0];
		shader.uEnabled.value = [false];
	}

	public function update(elapsed:Float):Void
	{
		shader.uTime.value[0] += elapsed;
	}

	function set_waveSpeed(v:Float):Float
	{
		waveSpeed = v;
		shader.uSpeed.value = [waveSpeed];
		return v;
	}

	function set_Enabled(v:Bool):Bool
	{
		Enabled = v;
		shader.uEnabled.value = [Enabled];
		shader.uampmul.value = [v ? 1.0 : 0.0];
		return v;
	}

	function set_waveFrequency(v:Float):Float
	{
		waveFrequency = v;
		shader.uFrequency.value = [waveFrequency];
		return v;
	}

	function set_waveAmplitude(v:Float):Float
	{
		waveAmplitude = v;
		shader.uWaveAmplitude.value = [waveAmplitude];
		return v;
	}
}

class PulseShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		#ifdef GL_ES
		precision mediump float;
		#endif

		uniform float uampmul;
		uniform float uTime;
		uniform float uSpeed;
		uniform float uFrequency;
		uniform float uWaveAmplitude;
		uniform bool uEnabled;

		vec4 sineWave(vec4 pt, vec2 pos)
		{
			float ampFactor = step(0.001, uampmul); // 0 or 1
			float offsetX = sin(pt.y * uFrequency + uTime * uSpeed);
			float offsetY = sin(pt.x * (uFrequency * 2.0) - (uTime / 2.0) * uSpeed);
			float offsetZ = sin(pt.z * (uFrequency / 2.0) + (uTime / 3.0) * uSpeed);
			pt.x = mix(pt.x, sin(pt.x / 2.0 * pt.y + (5.0 * offsetX) * pt.z), uWaveAmplitude * ampFactor);
			pt.y = mix(pt.y, sin(pt.y / 3.0 * pt.z + (2.0 * offsetZ) - pt.x), uWaveAmplitude * ampFactor);
			pt.z = mix(pt.z, sin(pt.z / 6.0 * (pt.x * offsetY) - (50.0 * offsetZ) * (pt.z * offsetX)), uWaveAmplitude * ampFactor);
			return vec4(pt.x, pt.y, pt.z, pt.w);
		}

		void main()
		{
			vec2 uv = openfl_TextureCoordv;
			gl_FragColor = sineWave(texture2D(bitmap, uv), uv);
		}
	')

	public function new() { super(); }
}
