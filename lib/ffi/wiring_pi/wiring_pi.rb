#frozen_string_literal: true

require 'ffi'
require 'ffi/wiring_pi/gpio'

module FFI
  module WiringPi
    extend FFI::Library
  end
end
