require_relative 'lib/ffi/wiring_pi/neopixel'

matrix = FFI::WiringPi::Neopixel::Matrix.new
matrix[:frequency] = 800_000 
matrix[:dmanum] = 10 # ??
matrix[:channel0][:gpionum] = 18 
matrix[:channel0][:count] = 44 * 11 # width * height
matrix[:channel0][:invert] = 0
matrix[:channel0][:brightness] = 255
matrix[:channel0][:strip_type] = FFI::WiringPi::Neopixel::WS2811_STRIP_RGB

count = 44 * 11

class Pixel < FFI::Struct
  layout  :value, :u_int32_t
end

raw_pixels = FFI::MemoryPointer.new(:u_int32_t, count)
pixels = []
pixels << Pixel.new(raw_pixels + 0 * Pixel.size )
pixels << Pixel.new(raw_pixels + 1 * Pixel.size )
pixels[0][:value] = 0x00201000
pixels[1][:value] = 0x00202020


FFI::WiringPi::Neopixel.init(matrix)
Pixel.new(matrix[:channel0][:leds])[:value] = pixels[0][:value]
Pixel.new(matrix[:channel0][:leds] + 1 * Pixel.size)[:value] = pixels[1][:value]

FFI::WiringPi::Neopixel.render(matrix)
sleep 10
FFI::WiringPi::Neopixel.finish(matrix)