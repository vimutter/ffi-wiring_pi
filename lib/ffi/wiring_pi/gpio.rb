#frozen_string_literal: true

module FFI::WiringPi::GPIO
  extend FFI::Library

  INPUT = 0
  OUTPUT = 1
  PWM_OUTPUT = 2
  GPIO_CLOCK = 3
  SOFT_PWM_OUTPUT = 4
  SOFT_TONE_OUTPUT = 5
  PWM_TONE_OUTPUT = 6

  LOW = 0
  HIGH = 1

  PUD_OFF = 0
  PUD_DOWN = 1
  PUD_UP = 2

  PWM_MODE_MS = 0
  PWM_MODE_BAL = 1


  ffi_lib 'wiringPi'

  attach_function :setup, :wiringPiSetup, [], :int
  attach_function :setup_as_gpio, :wiringPiSetupGpio, [], :int
  attach_function :setup_as_physical, :wiringPiSetupPhys, [], :int

  # This initialises wiringPi but uses the /sys/class/gpio interface rather
  # than accessing the hardware directly. This can be called as a non-root user
  # provided the GPIO pins have been exported before-hand using the gpio program.
  # Pin numbering in this mode is the native Broadcom GPIO numbers – the same as
  # wiringPiSetupGpio() above, so be aware of the differences between Rev 1 and Rev 2 boards.
  # Note: In this mode you can only use the pins which have been exported via the /sys/class/gpio
  #   interface before you run your program. You can do this in a separate shell-script, or by
  #   using the system() function from inside your program to call the gpio program.
  # Also note that some functions have no effect when using this mode as they’re
  # not currently possible to action unless called with root privileges.
  # (although you can use system() to call gpio to set/change modes if needed)
  #
  # @see http://wiringpi.com/reference/setup/
  attach_function :setup_system_mode, :wiringPiSetupSys, [], :int

  #
  # @param pin [Integer] pin position (depends on setup mode)
  # @param mode [Integer] `FFI::WiringPi::GPIO::INPUT`, `FFI::WiringPi::GPIO::OUTPUT`,
  #   `FFI::WiringPi::GPIO::PWM_OUTPUT` or `FFI::WiringPi::GPIO::GPIO_CLOCK`
  attach_function :set_pin_mode, :pinMode, [:int, :int], :void

  def get(pin, mode = FFI::WiringPi::GPIO::OUTPUT)
    set_pin_mode(pin, mode)
    Pin.new(pin, mode)
  end

  # @param pin [Integer] pin position (depends on setup mode)
  # @param mode [Integer] `FFI::WiringPi::GPIO::LOW` or `FFI::WiringPi::GPIO::HIGH`
  attach_function :digital_write, :digitalWrite, [:int, :int], :void

  # Write pin state (aka digital_write)
  #
  # @param pin [Integer] pin position (depends on setup mode)
  # @param state [Boolean] `true` to set to HIGH, `false` to set to LOW
  #
  def write(pin, state)
    digital_write(state ? HIGH : LOW)
  end

  # Sets pin to HIGH state
  #
  # @param pin [Integer] pin position (depends on setup mode)
  #
  def up(pin)
    write(pin, true)
  end

  # Sets pin to LOW state
  #
  # @param pin [Integer] pin position (depends on setup mode)
  #
  def down(pin)
    write(pin, false)
  end

  # @param pin [Integer] pin position (depends on setup mode)
  #
  # @returns [Integer] `FFI::WiringPi::GPIO::LOW` or `FFI::WiringPi::GPIO::HIGH`
  attach_function :digital_read, :digitalRead, [:int], :int

  # Read pin state (aka digital_read)
  #
  # @param pin [Integer] pin position (depends on setup mode)
  # @returns [Boolean] `true` if pin is in high state, `false` if in low
  #
  def read(pin)
    result = digital_read(pin)
    case result
    when LOW
      false
    when HIGH
      true
    else
      raise "Unknown result: #{result.inspect}"
    end
  end

  class Pin
    def initialize(position, mode)
      @position = position
      @mode = mode
    end

    def up!
      raise ArgumentError('Can only set in OUTPUT mode') && return unless @mode == OUTPUT
      GPIO.up(@position)
    end

    def down!
      raise ArgumentError('Can only set in OUTPUT mode') && return unless @mode == OUTPUT
      GPIO.down(@position)
    end
  end
end
