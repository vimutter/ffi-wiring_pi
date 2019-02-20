#frozen_string_literal: true

module FFI::WiringPi::SoftPwm
  extend FFI::Library

  ffi_lib 'wiringPi'

  attach_function :soft_pwm_create, :softPwmCreate, [:int, :int, :int], :int
  attach_function :soft_pwm_write, :softPwmWrite, [:int, :int], :void

  class Pin
    def initialize(pin, initial_state = 0, range = 100)
      raise ArgumentError, 'Range should be Integer > 0' unless range.is_a?(Integer) && range > 0
      raise ArgumentError, 'State should be within the range' unless initial_state.is_a?(Integer) && (0..range).cover?(initial_state)
      @pin = pin
      @range = range
      FFI::WiringPi::SoftPwm.soft_pwm_create pin, initial_state, range
    end

    def write(value)
      raise ArgumentError, 'Value should be within the range' unless value.is_a?(Integer) && (0..@range).cover?(value)
      FFI::WiringPi::SoftPwm.soft_pwm_write @pin, value
    end
  end
end

