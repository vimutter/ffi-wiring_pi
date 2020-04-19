require_relative 'lib/ffi/wiring_pi/neopixel'

$matrix = matrix = FFI::WiringPi::Neopixel::Matrix.new
matrix[:frequency] = 800_000 
matrix[:dmanum] = 10 # ??
matrix[:channel0][:gpionum] = 18 
matrix[:channel0][:count] = 44 * 11 # width * height
matrix[:channel0][:invert] = 0
matrix[:channel0][:brightness] = 255
#matrix[:channel0][:strip_type] = FFI::WiringPi::Neopixel::WS2812_STRIP
matrix[:channel0][:strip_type] = FFI::WiringPi::Neopixel::SK6812W_STRIP

COUNT = count = 44 * 11

class Pixel < FFI::Struct
  layout  :value, :u_int32_t
end
$white = 0xffffffff
red = 0x20200000 # Experimental

$raw_pixels = FFI::MemoryPointer.new(:u_int32_t, count)
$pixels = []

COUNT.times do |i|
	$pixels << Pixel.new($raw_pixels + i * Pixel.size)
end
def on

COUNT.times do |i|
  $pixels[i][:value] = (rand(10) >3 ) ? $white : 0x00000000 #(i % 2 == 0) ? white : red
end
end

def off
	COUNT.times do |i|
		$pixels[i][:value] = 0x00000000
end
end

FFI::WiringPi::Neopixel.init($matrix)
def send
COUNT.times do |i|
  Pixel.new($matrix[:channel0][:leds] + i * Pixel.size)[:value] = $pixels[i][:value]
end
end
delay = 0.01
1000.times do
	sleep delay
on
send
FFI::WiringPi::Neopixel.render matrix
sleep delay
off
send
FFI::WiringPi::Neopixel.render matrix
sleep delay
end
FFI::WiringPi::Neopixel.render(matrix)
sleep 10
FFI::WiringPi::Neopixel.finish(matrix)
