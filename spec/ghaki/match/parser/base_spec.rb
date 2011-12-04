require 'ghaki/match/parser/base'

module Ghaki module Match module Parser module Base_Testing
describe Base do
  EXACT_KEY  = 'FOUND'
  EXACT_VAL  = 'EXACT-RETURNED'
  EXACT_TEXT = 'FounD'
  EXACT_FAIL = 'THIS FOUND NOW'
  EXACT_WORDS = { EXACT_VAL => [EXACT_KEY] }

  BOUND_KEY = 'HERE'
  BOUND_VAL = 'BOUND-RETURNED'
  BOUND_TEXT = 'LOOK HERE NOW'
  BOUND_LOOKUP = { %r{\b#{BOUND_KEY}\b}i => BOUND_VAL }

  MISS_TEXT = 'INVALID'
  MISS_DEF = 'PASS_BACK'

  describe '#initialize' do

    context 'using no options' do
      it 'has empty match lookups' do
        Base.new.match_lookup.should be_empty
      end
    end

    context 'using option :match_lookup' do
      it 'accepts' do
        @subj = Base.new( :match_lookup => BOUND_LOOKUP )
        @subj.match_lookup.should_not be_empty
        @subj.match_text(BOUND_TEXT).should == BOUND_VAL
      end
    end

    context 'using option :match_words' do
      it 'accepts' do
        @subj = Base.new( :match_words => EXACT_WORDS )
        @subj.match_lookup.should_not be_empty
        @subj.match_text(EXACT_TEXT).should == EXACT_VAL
      end
    end

  end

  subject { Base.new }

  it { should respond_to :match_lookup  }
  it { should respond_to :match_lookup= }
  it { should respond_to :default_value  }
  it { should respond_to :default_value= }

  describe '#add_words' do
    before(:each) do
      subject.add_words EXACT_VAL => [EXACT_KEY]
    end
    it 'matches against exact text' do
      subject.match_text(EXACT_TEXT).should == EXACT_VAL
    end
    it 'does not match against boundary' do
      subject.match_text(EXACT_FAIL).should be_nil
    end
  end

  describe '#match_text' do

    before(:each) do
      subject.match_lookup = BOUND_LOOKUP
    end

    context 'when matched' do
      it 'passes specified value' do
        subject.match_text(BOUND_TEXT).should == BOUND_VAL
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

    before(:each) do
      subject.match_lookup = BOUND_LOOKUP
    end

    context 'when matched' do
      it 'should match' do
        subject.match_lines([BOUND_TEXT]).should == BOUND_VAL
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
