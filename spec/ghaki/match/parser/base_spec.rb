require 'ghaki/match/parser/base'

module Ghaki module Match module Parser module Base_Testing
describe Base do
  FIND_KEY = 'FOUND'
  FIND_VAL = 'RETURNED'
  GOOD_TEXT = 'SHOULD BE FOUND BY PARSER'
  MISS_TEXT = 'INVALID'
  MISS_DEF = 'PASS_BACK'

  subject do
    Base.new({
      %r{\b#{FIND_KEY}\b} => FIND_VAL,
    })
  end

  describe '#initialize' do
    context 'using option :match_words' do
      it 'accepts' do
        @subj = Base.new( :match_words => { FIND_VAL => [FIND_KEY] } )
        subject.match_text(GOOD_TEXT).should == FIND_VAL
      end
    end
  end

  describe '#add_words' do
    subject { Base.new }
    it 'generates match pairs' do
      subject.add_words FIND_VAL => [FIND_KEY]
      subject.match_text(GOOD_TEXT).should == FIND_VAL
    end
  end

  describe '#match_text' do

    context 'when matched' do
      it 'passes specified value' do
        subject.match_text(GOOD_TEXT).should == FIND_VAL
      end
    end

    context 'when unmatched' do
      let(:text) { MISS_TEXT }
      it 'returns nil without default' do
        subject.match_text(text).should == nil
      end
      it 'returns default if present' do
        subject.default_value = MISS_DEF
        subject.match_text(text).should == MISS_DEF
      end
      it 'yields to block if present' do
        yielded_action = false
        subject.match_text(text) do
          yielded_action = true
          MISS_DEF
        end.should == MISS_DEF
        yielded_action.should be_true
      end
      it 'passed default overrides existing' do
        subject.default_value = 'IGNORE'
        subject.match_text( text, :default_value => MISS_DEF ).should == MISS_DEF
      end
    end

  end

  describe '#match_lines' do

    context 'when matched' do
      it 'should match' do
        subject.match_lines([GOOD_TEXT]).should == FIND_VAL
      end
    end

    context 'when unmatched' do
      let(:lines) { [MISS_TEXT] }
      it 'returns nil without default' do
        subject.match_lines(lines).should == nil
      end
      it 'returns default if present' do
        subject.default_value = MISS_DEF
        subject.match_lines(lines).should == MISS_DEF
      end
      it 'passed default overrides existing' do
        subject.default_value = 'IGNORE'
        subject.match_lines( lines, :default_value => MISS_DEF ).should == MISS_DEF
      end
      it 'yields to block if present' do
        yielded_action = false
        subject.match_lines(lines) do
          yielded_action = true
          MISS_DEF
        end.should == MISS_DEF
        yielded_action.should be_true
      end
    end

  end

end
end end end end
