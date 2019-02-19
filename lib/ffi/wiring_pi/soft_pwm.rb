#frozen_string_literal: true

module FFI::WiringPi::SoftPwm
  extend FFI::Library

  ffi_lib 'wiringPi'

  attach_function :soft_pwm_create, :softPwmCreate, [:int, :int], :int
  attach_function :soft_pwm_write, :softPwmWrite, [:int, :int], :void
end

