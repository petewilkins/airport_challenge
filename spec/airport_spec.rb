require 'airport'

describe Airport do
  let(:plane) { double :plane, flying?: true }
  subject(:airport) { described_class.new }

  describe "#initialize" do
    it 'checks default maximum capacity' do
      expect(subject.capacity).to eq Airport::DEFAULT_CAPACITY
    end

    it 'checks default capacity can be changed' do
      subject = Airport.new(50)
      expect(subject.capacity).to eq 50
    end
  end

  describe "#land" do
    context 'when not stormy' do
      before do
        allow(subject.weather).to receive(:stormy?) {false}
        allow(plane).to receive(:land)
      end

      it 'responds to land' do
        expect(subject).to respond_to :land
      end

      it 'land takes 1 argument' do
        expect(subject).to respond_to(:land).with(1).argument
      end

      it 'lands a plane' do
        expect(subject.land(plane)).to eq [plane]
      end

      it 'has the plane after landing' do
        subject.land(plane)
        expect(subject.planes).to include plane
      end

      it 'error raised if plane not flying' do
        plane = double(:plane, flying?: false)
        expect{subject.land(plane)}.to raise_error("Plane already landed")
      end

      context 'when full' do
        it 'raises an error' do
          subject.capacity.times {subject.land(plane)}
          expect{subject.land(plane)}.to raise_error("Airport Full")
        end
      end


    end
    context 'when stormy' do
      it 'error raised if landing' do
        allow(subject.weather).to receive(:stormy?) {true}
        expect{subject.land(plane)}.to raise_error("Weather Warning, can't land plane")
      end
    end
  end

  describe "#take_off" do
    context 'when not stormy' do
      before do
        allow(subject.weather).to receive(:stormy?) {false}
        allow(plane).to receive(:land)
        allow(plane).to receive(:take_off)
      end
      it 'responds to take_off' do
        expect(subject).to respond_to :take_off
      end

      it 'take_off takes 1 argument' do
        expect(subject).to respond_to(:take_off).with(1).argument
      end

      it 'airport no longer has the plane' do
        subject.land(plane)
        allow(plane).to receive(:flying?) {false}
        subject.take_off(plane)
        expect(subject.planes).not_to include plane
      end
    end

    context 'when stormy' do
      it 'error raised if a plane takes off in stormy conditions' do
        plane = double(:plane, flying?: false)
        subject.planes << plane
        allow(subject.weather).to receive(:stormy?) {true}
        expect{subject.take_off(plane)}.to raise_error("Weather Warning, can't take off")
      end
    end
  end
end
