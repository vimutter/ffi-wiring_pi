#frozen_string_literal: true

module FFI::WiringPi::Pcf8591
  extend FFI::Library

  ffi_lib 'wiringPi'

  attach_function :setup, :pcf8591Setup, [:int, :int], :void
end

