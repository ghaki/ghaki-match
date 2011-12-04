require 'ghaki/match/mixin/auto_boolean'

module Ghaki module Match module Mixin module AutoBoolean_Testing
describe AutoBoolean do

  GOOD_KEY = 'EXPECTED'
  GOOD_TRUE = 'TRUE'
  MISS_KEY = 'INVALID'
  MISS_VAL = 'BOGUS'
  FIELDS_EXP = [GOOD_KEY]

  class UsingAuto
    include AutoBoolean
  end

  subject { UsingAuto.new }

  it { should respond_to :auto_boolean_matcher= }

  describe '#auto_boolean_matcher' do
    it 'creates when not initialized' do
      subject.auto_boolean_matcher.should be_kind_of(Parser::Boolean)
    end
    it 'accepts initialized value' do
      parser = Parser::Boolean.new
      subject.auto_boolean_matcher = parser
      subject.auto_boolean_matcher.should == parser
    end
  end

  describe '#boolean_lookup' do
    it 'defaults to empty list' do
      subject.boolean_lookup.should be_empty
    end
    it 'returns truthiness when field is present' do
      subject.boolean_lookup = FIELDS_EXP
      subject.boolean_field( GOOD_KEY, GOOD_TRUE ).should be_true
    end
    it 'returns orginal when field is missing' do
      subject.boolean_lookup = FIELDS_EXP
      subject.boolean_field( MISS_KEY, GOOD_TRUE ).should == GOOD_TRUE
    end
  end

  describe '#boolean_value' do

    context 'using defaults' do
      context 'with known values' do
        Parser::Boolean::DEFAULT_VALUES[true].each do |item|
          it "returns true for: #{item}" do
              subject.boolean_value(item).should be_true
            end
          end
        end
        Parser::Boolean::DEFAULT_VALUES[false].each do |item|
          it "returns false for: #{item}" do
              subject.boolean_value(item).should be_false
          end
        end
      end
      context 'with unknown values' do
        it 'returns original value' do
          subject.boolean_value(MISS_VAL).should == MISS_VAL
        end
      end

  end

  describe '#boolean_field' do
    context 'with present field' do
      it 'converts value to boolean' do
        subject.boolean_lookup = FIELDS_EXP
        subject.boolean_field(GOOD_KEY,GOOD_TRUE).should be_true
      end
    end
    context 'with invalid field' do
      it 'returns original value' do
        subject.boolean_field(MISS_KEY,MISS_VAL).should == MISS_VAL
      end
    end
  end

end
end end end end
