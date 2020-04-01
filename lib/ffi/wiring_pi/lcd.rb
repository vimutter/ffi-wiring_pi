#frozen_string_literal: true

module FFI::WiringPi::LCD
  extend FFI::Library

  ffi_lib 'wiringPi'
  # ws2811_return_t ws2811_init(ws2811_t *ws2811);                         //< Initialize buffers/hardware
  # void ws2811_fini(ws2811_t *ws2811);                                    //< Tear it all down
  # ws2811_return_t ws2811_render(ws2811_t *ws2811);                       //< Send LEDs off to hardware
  # ws2811_return_t ws2811_wait(ws2811_t *ws2811);                         //< Wait for DMA completion
  # const char * ws2811_get_return_t_str(const ws2811_return_t state);     //< Get string representation of the given return state

  # attach_function :setup, :wiringPiSetup, [], :int
  # int  lcdInit (int rows, int cols, int bits, int rs, int strb,
  #       int d0, int d1, int d2, int d3, int d4, int d5, int d6, int d7) ;

  attach_function :lcdInit, :lcdInit, [:int, :int, :int, :int, :int, :int, :int, :int, :int, :int, :int, :int, :int], :int

  # lcdHome (int handle)
  # lcdClear (int handle)
  attach_function :lcdHome, :lcdHome, [:int], :void
  attach_function :lcdClear, :lcdClear, [:int], :void

  # lcdDisplay (int fd, int state)
  attach_function :lcdDisplay, :lcdDisplay, [:int, :int], :void
  # lcdCursor (int fd, int state)
  attach_function :lcdCursor, :lcdClear, [:int, :int], :void
  # lcdCursorBlink (int fd, int state)
  attach_function :lcdCursorBlink, :lcdCursorBlink, [:int, :int], :void

  # Set the position of the cursor for subsequent text entry.
  # x is the column and 0 is the left-most edge. y is the line and 0 is the top line.
  # lcdPosition (int handle, int x, int y) ;
  attach_function :lcdPosition, :lcdPosition, [:int, :int, :int], :void

  # This allows you to re-define one of the 8 user-definable chanracters in the display.
  # The data array is 8 bytes which represent the character from the top-line to the bottom line.
  # Note that the characters are actually 5×8, so only the lower 5 bits are used.
  # The index is from 0 to 7 and you can subsequently print the character defined using the lcdPutchar() call.
  #
  # lcdCharDef (int handle, int index, unsigned char data[] [8]) ;
  attach_function :lcdCharDef, :lcdCharDef, [:int, :int, :pointer], :void

  # lcdPutchar (int handle, unsigned char data) ;
  attach_function :lcdPutchar, :lcdPutchar, [:int, :pointer], :void
  # lcdPuts (int handle, const char *string) ;
  attach_function :lcdPuts, :lcdPuts, [:int, :string], :void
  # lcdPrintf (int handle, const char *message, …) ;
  attach_function :lcdPrintf, :lcdPrintf, [:int, :string, :varargs], :void

  class Display
    def initialize(params)
      @handle = FFI::WiringPi::LCD.lcdInit(
        params[:rows], params[:cols], params[:bits], params[:rs],
        params[:strb], params[:d0], params[:d1], params[:d2], params[:d3],
        params[:d4], params[:d5], params[:d6], params[:d7]
      )
    end

    def home
      FFI::WiringPi::LCD.lcdHome(@handle)
    end

    def clear
      FFI::WiringPi::LCD.lcdClear @handle
    end

    def turn_display(state)
      FFI::WiringPi::LCD.lcdDisplay(@handle, state ? 1 : 0)
    end

    def turn_cursor(state)
      FFI::WiringPi::LCD.lcdCursor(@handle, state ? 1 : 0)
    end

    def turn_cursor_blink(state)
      FFI::WiringPi::LCD.lcdCursorBlink(@handle, state ? 1 : 0)
    end

    def set_characters(index, data)
      FFI::WiringPi::LCD.lcdCharDef(@handle, index, data[0...8])
    end

    def set_position(x, y)
      FFI::WiringPi::LCD.lcdPosition(@handle, x, y)
    end

    def print(data)
      FFI::WiringPi::LCD.lcdPutchar(@handle, data)
    end

    def puts(data)
      FFI::WiringPi::LCD.lcdPuts(@handle, data)
    end

    def printf(format, *args)
      FFI::WiringPi::LCD.lcdPuts(@handle, format, *args)
    end
  end
end

