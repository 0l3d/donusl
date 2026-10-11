# Written in SL Editor Completely.
use("io", "math", "console", "list", "string", "types", "errors")

var SCREEN_WIDTH = 80
var SCREEN_HEIGHT = 24
var SCREEN_SIZE = $SCREEN_WIDTH * $SCREEN_HEIGHT

var r1 = 0.0
var r2 = 0.0

var zbuffer = List.new($SCREEN_SIZE)


var frame_counter = 0

while true then
	var screen = ""
	List.clear($zbuffer)

	var i = 0 
	while $i < $SCREEN_SIZE then
		$screen = $screen + " "
		List.push($zbuffer, 0.0)
		$i = $i + 1
	end

	var b = 0.0
	while $b < 6.28 then
		var sin_b = math.sin($b)
		var cos_b = math.cos($b)
		var sin_r1 = math.sin($r1)
		var cos_r1 = math.cos($r1)
		var sin_r2 = math.sin($r2)
		var cos_r2 = math.cos($r2)
		var h = $cos_b + 2.0
		var a = 0.0
		while $a < 6.28 then
			var sin_a = math.sin($a)
			var cos_a = math.cos($a)

			   var depth = 1.0 / ($sin_a * $h * $sin_r1 + $sin_b * $cos_r1 + 5.0)

			var temp = $sin_a * $h * $cos_r1 - $sin_b * $sin_r1

			var x = types.double_to_int(
				40.0 + 30.0 * $depth * ($cos_a * $h * $cos_r2 - $temp * $sin_r2))

			var y = types.double_to_int(
				12.0 + 15.0 * $depth * ($cos_a * $h * $sin_r2 + $temp * $cos_r2))

			var luminance = 8.0 * (($sin_b * $sin_r1 - $sin_a * $cos_b * $cos_r1) * $cos_r2 - $sin_a * $cos_b * $sin_r1 - $sin_b * $cos_r1 - $cos_a * $cos_b * $sin_r2)
			
			if $y eqg 0 and $y < $SCREEN_HEIGHT and $x eqg 0 and $x < $SCREEN_WIDTH then
				var screen_idx = $x + $SCREEN_WIDTH * $y
				var zbuf = List.get($zbuffer, $screen_idx)
				if $depth > $zbuf then
					List.set($zbuffer, $screen_idx, $depth)
					var chars = ".,-~:;=!*#$@"
					var char_idx = 0
					if $luminance > 0.0 then
						$char_idx = types.double_to_int($luminance)
						var len = string.len($chars)
   						if $char_idx eqg $len then
							$char_idx = $len - 1
   						end					
					else
						$char_idx = 0
					end
					$screen = string.set_char_at($screen, $screen_idx, string.char_at($chars, $char_idx))
				end
			end
			$a = $a + 0.02
		end
		$b = $b + 0.07
	end

	console.clear()

	var j = 0
	while $j < $SCREEN_SIZE then
    		io.print(string.char_at($screen, $j))

		if ($j + 1) % $SCREEN_WIDTH equ 0 then
			io.print("\n")
		end
		$j = $j + 1
	end

	io.flush()
	$r1 = $r1 + 0.04
	$r2 = $r2 + 0.02
end
