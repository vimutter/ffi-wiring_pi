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
raw_pixels = FFI::MemoryPointer.new(:uint32_t, count)
raw_pixels[0] = 0x00201000
raw_pixels[1] = 0x00202020


FFI::WiringPi::Neopixel.init(matrix)
matrix[:channel0][:leds][0] = raw_pixels[0]
matrix[:channel0][:leds][1] = raw_pixels[1]


FFI::WiringPi::Neopixel.render(matrix)
sleep 10
FFI::WiringPi::Neopixel.finish(matrix)