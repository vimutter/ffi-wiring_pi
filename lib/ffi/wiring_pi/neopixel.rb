#frozen_string_literal: true

module FFI::WiringPi::Neopixel
  extend FFI::Library

  ffi_lib 'libws281x'
  # ws2811_return_t ws2811_init(ws2811_t *ws2811);                         //< Initialize buffers/hardware
  # void ws2811_fini(ws2811_t *ws2811);                                    //< Tear it all down
  # ws2811_return_t ws2811_render(ws2811_t *ws2811);                       //< Send LEDs off to hardware
  # ws2811_return_t ws2811_wait(ws2811_t *ws2811);                         //< Wait for DMA completion
  # const char * ws2811_get_return_t_str(const ws2811_return_t state);     //< Get string representation of the given return state

  # attach_function :setup, :wiringPiSetup, [], :int

end
