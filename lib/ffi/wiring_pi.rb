#frozen_string_literal: true

#frozen_string_literal: true

require 'ffi'

module FFI
  module WiringPi
    extend FFI::Library
  end
end

require 'ffi/wiring_pi/gpio'
