require 'spec_helper'

RSpec.describe FFI::WiringPi::GPIO do

  describe '.batch_write' do
    shared_examples_for 'byte converter' do |byte, array|
      it 'converts boolean array to byte' do
        expect(described_class).to receive(:digital_write_byte).with(byte)
        described_class.batch_write array
      end
    end

    it_behaves_like 'byte converter', 1, [true, false, false, false,  false, false, false, false]
    it_behaves_like 'byte converter', 2, [false, true, false, false,  false, false, false, false]
    it_behaves_like 'byte converter', 3, [true, true, false, false,  false, false, false, false]
    it_behaves_like 'byte converter', 17, [true, false, false, false,  true, false, false, false]
  end
end
