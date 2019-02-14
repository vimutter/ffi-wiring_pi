# ffi-wiring-pi

[![Gem Version](https://badge.fury.io/rb/ffi-wiring_pi.svg)](https://badge.fury.io/rb/ffi-wiring_pi)

* [Source](https://github.com/vimutter/ffi-wiring_pi/)
* [Issues](https://github.com/vimutter/ffi-wiring_pi/issues)

## Description

Ruby FFI bindings for the [wiringPi](http://wiringpi.com) library.

## Features

* Can setup and work with GPIO

## Examples

Setup GPIO:

    require 'ffi/wiring_pi'

    # Will setup with wiringPi pin numbering scheme
    FFI::WiringPi::GPIO.setup
    FFI::WiringPi::GPIO.set_pin_mode(0, FFI::WiringPi::GPIO::OUTPUT)
    FFI::WiringPi::GPIO.write(0, true)
    # Or
    FFI::WiringPi::GPIO.up(0)
    # Or
    pin = FFI::WiringPi::GPIO.get(0)
    pin.up!

## Requirements

* [Ruby](http://ruby-lang.org/) >= 2.6.1 or
* [wiringPi](http://wiringpi.com/download-and-install/) >= 2.46
* [ffi](http://github.com/ffi/ffi) ~> 1.0

## Install

    $ gem install ffi-wiring_pi

## License

Copyright (c) 2019 Mark Huk

See [Licence](LICENSE.txt) for license information.
