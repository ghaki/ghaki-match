require 'ghaki/match/finder'

module Ghaki module Match module Finder_Testing
describe Ghaki::Match::Finder do

  subject do
    Ghaki::Match::Finder.new([
      %r{\bquack\b},
      %r{\bmoo\b},
    ])
  end

  describe '#match_text' do
    it 'should match' do
      subject.match_text('moo cow').should == true
    end
    it 'should not match' do
      subject.match_text('zip zap').should == false
    end
  end

  describe '#match_lines' do
    it 'should match' do
      subject.match_lines(['quick quack']).should == true
    end
    it 'should not match' do
      subject.match_lines(['zip zap']).should == false
    end
  end

end
end end end
