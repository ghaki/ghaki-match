require 'ghaki/match/parser/boolean'

module Ghaki module Match module Parser module Boolean_Testing
describe Boolean do

  FIELDS_EXP = ['EXPECTED']
  EXTRA_KEY = 'ZAP'
  EXTRA_TEXT = 'ZIP ZAP ZOOM'

  it { should respond_to :boolean_lookup }
  it { should respond_to :boolean_lookup= }
  
  describe '#initialize' do

    context 'using option :boolean_lookup' do
      it 'accepts when given' do
        @subj = Boolean.new( :boolean_lookup => FIELDS_EXP )
        @subj.boolean_lookup.should == FIELDS_EXP
      end
      it 'defaults as empty' do
        @subj = Boolean.new
        @subj.boolean_lookup.should be_empty
      end
    end

    context 'using option :skip_boolean_defaults' do
      it 'ignores defaults when specified' do
        @subj = Boolean.new( :skip_boolean_defaults => true )
        @subj.lookups.should be_empty
      end
      it 'imports defaults when missing' do
        @subj = Boolean.new
        @subj.lookups.should_not be_empty
      end
    end

    context 'using option :boolean_trues' do
      it 'accepts when given' do
        @subj = Boolean.new( :boolean_trues => EXTRA_KEY )
        @subj.match_text(EXTRA_TEXT).should be_true
      end
    end

    context 'using option :boolean_falses' do
      it 'accepts when given' do
        @subj = Boolean.new( :boolean_falses => EXTRA_KEY )
        @subj.match_text(EXTRA_TEXT).should be_false
      end
    end

  end

  describe '#parse_value' do

    subject { Boolean.new }

    context 'when unmatched' do
      let(:text) { 'INVALID' }
      it 'passes through original value' do
        subject.parse_value(text).should == text
      end
      it 'yields to block if present' do
        yielded = false
        subject.parse_value(text) do
          yielded = true
          'RETURNED'
        end.should == 'RETURNED'
        yielded.should be_true
      end
    end

    context 'using matched defaults' do
      Boolean::DEFAULT_VALUES[true].each do |item|
        it "returns true given: #{item}" do
          subject.parse_value(item).should be_true
        end
      end
      Boolean::DEFAULT_VALUES[false].each do |item|
        it "returns false given: #{item}" do
          subject.parse_value(item).should be_false
        end
      end
    end

  end

  describe '#parse_field' do

    subject { Boolean.new :boolean_lookup => FIELDS_EXP }

    context 'with present field' do

      let(:field) { FIELDS_EXP.first }

      context 'when unmatched' do
        let(:text) { 'NOT_FOUND' }
        it 'passes through original value' do
          subject.parse_field( field, text ).should == text
        end
        it 'yields to block if present' do
          yielded = false
          subject.parse_field( field, text ) do
            yielded = true
            'PASSED_BACK'
          end.should == 'PASSED_BACK'
          yielded.should be_true
        end
      end

      context 'using matched defaults' do
        Boolean::DEFAULT_VALUES[true].each do |item|
          it "returns true given: #{item}" do
            subject.parse_field( field, item ).should be_true
          end
        end
        Boolean::DEFAULT_VALUES[false].each do |item|
          it "returns false given: #{item}" do
            subject.parse_field( field, item ).should be_false
          end
        end
      end

    end

    context 'with missing field' do
      let(:field) { 'INVALID' }
      let(:text)  { 'PASSED_BACK' }
      it 'passes through original value' do
        subject.parse_field( field, text ).should == text
      end
    end

  end

end
end end end end
