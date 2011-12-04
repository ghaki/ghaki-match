require 'ghaki/match/mixin/auto_rename'

module Ghaki module Match module Mixin module AutoRename_Testing
describe AutoRename do

  FIELD_CLEANUP_EXAMPLES = {
    'accepts numbers and letters' => {
      'phasellus_tortor_elementum'   => 'phasellus_tortor_elementum',
      'Nulla Nisl 801 Leo Porta Et'  => 'nulla_nisl_801_leo_porta_et',
    },
    'removes garbage' => {
      'Lorem ipsum dolor-sit amet.'   => 'lorem_ipsum_dolor_sit_amet',
      'Fermentum / Augue (FRINGILLA)' => 'fermentum_augue_fringilla',
    },
  }

  class UsingAuto
    include AutoRename
  end
  before(:each) do
    @subj = UsingAuto.new
  end
  subject { @subj }

  it { should respond_to :auto_tokenize? }
  it { should respond_to :auto_tokenize! }

  it { should respond_to :field_renames= }
  describe '#field_renames' do
    it 'defaults empty hash' do
      subject.field_renames.should == {}
    end
    it 'returns set value' do
      thing = { 'zip' => 'zap' }
      subject.field_renames = thing
      subject.field_renames.should == thing
    end
  end

  describe '#format_field' do
    FIELD_CLEANUP_EXAMPLES.each_pair do |reason,examples|
     it reason do
        examples.each_pair do |key,val|
          subject.format_field(key).should == val
        end
      end
    end
  end

  describe '#rename_field' do

    ARF_RULES = {
      'phasellus_tortor_elementum' => true,                   # clean and token
      'lorem_ipsum_dolor_sit_amet' => :amet_lorem_dolor_sit,  # set specific
      'nulla_nisl_801_porta'       => false,                  # just clean
    }

    ARF_EXPECTED = {
      'cleans and tokenizes' => {
        'phasellus_tortor_elementum' => :phasellus_tortor_elementum,
      },
      'renames to specific' => {
        'Lorem ipsum dolor sit amet.' => :amet_lorem_dolor_sit,
      },
      'cleans only' => {
        'Nulla Nisl 801 Porta' => 'nulla_nisl_801_porta',      # clean
      },
    }

    before(:each) do
      subject.field_renames = ARF_RULES
    end

    context 'with matched' do
      ARF_EXPECTED.each_pair do |reason,examples|
        it "#{reason} by rule" do
          examples.each_pair do |get,put|
            subject.rename_field(get).should == put
          end
        end
      end
    end

    context 'with unknown' do
      let(:get_field) { 'UNKNOWN' }
      let(:put_token) { :unknown }
      let(:put_clean) { 'unknown' }

      context 'using set :auto_tokenize' do

        it 'translates unknown into Symbol' do
          subject.auto_tokenize! true
          subject.rename_field(get_field).should == put_token
        end

        it 'translates unknown into String' do
          subject.auto_tokenize! false
          subject.rename_field(get_field).should == put_clean
        end

        it 'fails when not set' do
          lambda do
            subject.rename_field('missing')
          end.should raise_error( ArgumentError, 'Unknown Auto Rename Field Value: missing' )
        end

      end

      context 'using option :auto_tokenize' do

        it 'accepts :auto_tokenize when true' do
          subject.rename_field( get_field, :auto_tokenize => true ).should == put_token
        end

        it 'accepts :auto_tokenize when false' do
          subject.rename_field( get_field, :auto_tokenize => false ).should == put_clean
        end

        it 'fails when not set' do
          lambda do
            subject.rename_field('missing')
          end.should raise_error( ArgumentError, 'Unknown Auto Rename Field Value: missing' )
        end
      end

    end

  end

end
end end end end
