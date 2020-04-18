#frozen_string_literal: true

module FFI::WiringPi::Neopixel
  extend FFI::Library

  ffi_lib 'libws281x'
  # typedef struct ws2811_channel_t
  # {
  #     int gpionum;                                 //< GPIO Pin with PWM alternate function, 0 if unused
  #     int invert;                                  //< Invert output signal
  #     int count;                                   //< Number of LEDs, 0 if channel is unused
  #     int strip_type;                              //< Strip color layout -- one of WS2811_STRIP_xxx constants
  #     ws2811_led_t *leds;                          //< LED buffers, allocated by driver based on count
  #     uint8_t brightness;                          //< Brightness value between 0 and 255
  #     uint8_t wshift;                              //< White shift value
  #     uint8_t rshift;                              //< Red shift value
  #     uint8_t gshift;                              //< Green shift value
  #     uint8_t bshift;                              //< Blue shift value
  #     uint8_t *gamma;                              //< Gamma correction table
  # } ws2811_channel_t;
  #typedef uint32_t ws2811_led_t;                   //< 0xWWRRGGBB

  class Channel < FFI::Struct
    layout  :gpionum, :int,
      :invert, :int,
      :count, :int,
      :strip_type, :int,
      :leds, :pointer,
      :brightness, :uint8_t,
      :wshift, :uint8_t,
      :rshift, :uint8_t,
      :gshift, :uint8_t,
      :bshift, :uint8_t,
      :gamma, :pointer
  end

  # typedef struct ws2811_t
  # {
  #     uint64_t render_wait_time;                   //< time in µs before the next render can run
  #     struct ws2811_device *device;                //< Private data for driver use
  #     const rpi_hw_t *rpi_hw;                      //< RPI Hardware Information
  #     uint32_t freq;                               //< Required output frequency
  #     int dmanum;                                  //< DMA number _not_ already in use
  #     ws2811_channel_t channel[RPI_PWM_CHANNELS];
  # } ws2811_t;
  RPI_PWM_CHANNELS = 2 # ??
  WS2811_STRIP_RGB = 0x00100800

  class Matrix < FFI::Struct
    layout  :render_wait_time, :uint64_t,
      :device, :pointer, 
      :rpi_hw, :pointer,
      :frequency, :uint32_t,
      :dmanum, :int,
      :channel0, Channel,
      :channel1, Channel
  end


  enum :return_status, [
      WS2811_SUCCESS, 0, 
      WS2811_ERROR_GENERIC, -1, 
      WS2811_ERROR_OUT_OF_MEMORY, -2, 
      WS2811_ERROR_HW_NOT_SUPPORTED, -3, 
      WS2811_ERROR_MEM_LOCK, -4, 
      WS2811_ERROR_MMAP, -5, 
      WS2811_ERROR_MAP_REGISTERS, -6, 
      WS2811_ERROR_GPIO_INIT, -7, 
      WS2811_ERROR_PWM_SETUP, -8, 
      WS2811_ERROR_MAILBOX_DEVICE, -9, 
      WS2811_ERROR_DMA, -10, 
      WS2811_ERROR_ILLEGAL_GPIO, -11, 
      WS2811_ERROR_PCM_SETUP, -12, 
      WS2811_ERROR_SPI_SETUP, -13, 
      WS2811_ERROR_SPI_TRANSFER, -14 
    ] 

  # ws2811_return_t ws2811_init(ws2811_t *ws2811);                         //< Initialize buffers/hardware
  attach_function :init, :ws2811_init, [ Matrix ], :return_status

  # void ws2811_fini(ws2811_t *ws2811);                                    //< Tear it all down
  attach_function :finish, :ws2811_fini, [ Matrix ], :void

  # ws2811_return_t ws2811_render(ws2811_t *ws2811);                       //< Send LEDs off to hardware

  attach_function :render, :ws2811_render, [ Matrix ], :return_status

  # ws2811_return_t ws2811_wait(ws2811_t *ws2811);                         //< Wait for DMA completion

  attach_function :wait, :ws2811_wait, [ Matrix ], :return_status
end
