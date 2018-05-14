RSpec.describe EveDropCall do
  it "has a version number" do
    expect(EveDropCall::VERSION).not_to be nil
  end

  describe '#eavesdrop' do
    subject(:eavesdrop){ EveDropCall.eavesdrop(target) }
    let(:target) do
      Class.new do
        class << self
          def x
            Callstack.puts "Target.x"
            new.x
          end
        end

        def x
          Callstack.puts "Target#x"
        end
      end
    end

    it{ is_expected.to eq target }

    describe 'can eavesdrop?' do
      before{ eavesdrop }
      subject{ target.x }

      # p = PrependKlass
      # t = TargetKlass

      # marked call stack is expected
      # #=> p.x > t.x > p#new > p#x > t#x
      it { expect{ target.x }.to change{ Callstack.list.size }.to(5) }
    end
  end
end
