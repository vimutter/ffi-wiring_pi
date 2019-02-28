require 'spec_helper'

RSpec.describe FFI::WiringPi::SoftTone do

  before :each do
    allow(FFI::WiringPi::SoftTone).to receive(:soft_tone_create).and_return 0
  end

  describe '::Pin' do
    it 'raises error when soft_tone_create returns non-zero' do
      allow(FFI::WiringPi::SoftTone).to receive(:soft_tone_create).and_return 1
      expect { described_class::Pin.new 0 }.to raise_error('Something went wrong: Errno:0')
    end

    describe '#write' do
      subject do
        described_class::Pin.new 0
      end

      it 'calls soft_tone_write', :aggregate_failures do
        expect(FFI::WiringPi::SoftTone).to receive(:soft_tone_write).with(0, 100)
        subject.write(100)
      end
    end
  end
end
