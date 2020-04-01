#frozen_string_literal: true

module FFI::WiringPi::Pcf8574
  extend FFI::Library

  ffi_lib 'wiringPi'

  attach_function :setup, :pcf8574Setup, [:int, :int], :void
end

