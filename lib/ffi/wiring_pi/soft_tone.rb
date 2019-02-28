#frozen_string_literal: true

module FFI::WiringPi::SoftTone
  extend FFI::Library

  ffi_lib 'wiringPi'

  attach_function :soft_tone_create, :softToneCreate, [:int], :int
  attach_function :soft_tone_write, :softToneWrite , [:int, :int], :void

  class Pin
    def initialize(pin)
      @pin = pin
      status = FFI::WiringPi::SoftTone.soft_tone_create pin
      raise "Something went wrong: Errno:#{FFI::LastError.error}" unless status == 0
    end

    # Sets the frequency of software PWM in tone mode (50%)
    # @param frequecy [Integer] if 0 - disable output, if less than 5000 usually
    # produces sound (if connected to devise)
    def write(frequecy)
      FFI::WiringPi::SoftTone.soft_tone_write @pin, frequecy
    end
  end
end

