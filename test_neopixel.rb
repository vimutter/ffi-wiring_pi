require_relative 'lib/ffi/wiring_pi/neopixel'

matrix = FFI::WiringPi::Neopixel::Matrix.new
matrix[:frequency] = 800_000 
matrix[:dmanum] = 10 # ??
matrix[:channel0][:gpionum] = 18 
matrix[:channel0][:count] = 44 * 11 # width * height
matrix[:channel0][:invert] = 0
matrix[:channel0][:brightness] = 255
#matrix[:channel0][:strip_type] = FFI::WiringPi::Neopixel::WS2812_STRIP
matrix[:channel0][:strip_type] = FFI::WiringPi::Neopixel::SK6812W_STRIP

count = 44 * 11

class Pixel < FFI::Struct
  layout  :value, :u_int32_t
end
white = 0x00202020
red = 0xffff0000 # Experimental

raw_pixels = FFI::MemoryPointer.new(:u_int32_t, count)
pixels = []
count.times do |i|
  pixels << Pixel.new(raw_pixels + i * Pixel.size )
  pixels[i][:value] = (i % 2 == 0) ? white : red
end

FFI::WiringPi::Neopixel.init(matrix)
count.times do |i|
  Pixel.new(matrix[:channel0][:leds] + i * Pixel.size)[:value] = pixels[i][:value]
end

FFI::WiringPi::Neopixel.render(matrix)
sleep 10
FFI::WiringPi::Neopixel.finish(matrix)