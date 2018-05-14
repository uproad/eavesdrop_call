RSpec.describe EveDropCall do
  it "has a version number" do
    expect(EveDropCall::VERSION).not_to be nil
  end

  describe '#eavesdrop' do
    subject(:eavesdrop){ EveDropCall.eavesdrop(target, File.expand_path(File.dirname(__FILE__))) }
    let(:target) do
      TargetKlass = Class.new do
        class << self
          def x
            new.x
          end
        end

        def x
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
      it { expect{ target.x }.to change{ Callstack.list.size }.to(3) }
    end
  end
end
