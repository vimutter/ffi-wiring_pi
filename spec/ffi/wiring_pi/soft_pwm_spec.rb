require 'spec_helper'

RSpec.describe FFI::WiringPi::SoftPwm do

  before :each do
    allow(FFI::WiringPi::SoftPwm).to receive(:soft_pwm_create)
  end

  describe '::Pin' do
    it 'raises error when range is negative' do
      expect { described_class::Pin.new 0, 0, -1 }.to raise_error('Range should be Integer > 0')
    end

    it 'raises error when initial state is negative' do
      expect { described_class::Pin.new 0, -1, 100 }.to raise_error('State should be within the range')
    end

    it 'raises error when initial state is out of range' do
      expect { described_class::Pin.new 0, 101, 100 }.to raise_error('State should be within the range')
    end

    describe '#write' do
      subject do
        described_class::Pin.new 0, 0, 100
      end

      it 'raises error when value is out of range', :aggregate_failures do
        expect { subject.write(-1) }.to raise_error('Value should be within the range')
        expect { subject.write(101) }.to raise_error('Value should be within the range')
      end
    end
  end
end
