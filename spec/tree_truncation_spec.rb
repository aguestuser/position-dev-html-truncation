# coding: utf-8
require 'tree_truncation'
include TreeTruncation

RSpec.describe TreeTruncation do

  describe'main functions' do

    describe '#Render' do
      t1 = 
        Branch['p', [
          Leaf['You never '],
          Branch['strong', [
            Leaf['did the '],
            Branch['em', [
              Leaf['Kenosha']]],
            Leaf[' Kid']]],
          Leaf['.']]]

      it 'renders a Tree into an html string' do
        Render[t1].should eq "<p>You never <strong>did the <em>Kenosha</em> Kid</strong>.</p>"
      end
    end

    describe '#Truncate' do

      t2 = 
        Branch['p', [
          Leaf['You never'],
          Branch['strong', [
            Leaf['did the'],
            Branch['em', [
              Leaf['Kenosha']]],
            Leaf['Kid']]],
          Leaf['.']]]
    
      # TODO:
      # * fix whitespace
      #   * this currenly only works for html w/ no white space at beginning or end of tokens!!!
      #   * requires modification of Truncation::Tokenize/Detokenize to work properly
      # * off-by one errors (see tests)

      context 'tree contains less characters than the limit' do
        it 'does not mutate the tree' do
          Truncate[t2, 500].should eq "<p>You never<strong>did the<em>Kenosha</em>Kid</strong>.</p>"
        end
      end

      context 'tree contains an equal number of characters as the limit' do
        it 'does not mutate the tree' do
          # off-by one: (should pass for limit of 26)
          Truncate[t2, 27].should eq "<p>You never<strong>did the<em>Kenosha</em>Kid</strong>.</p>"
        end
      end
      
      it 'removes all characters and tags occuring after a character limit' do
        Truncate[t2, 0].should eq "" # desired semantics?
        Truncate[t2, 1].should eq "<p>…</p>"
        Truncate[t2, 2].should eq "<p>…</p>"
        Truncate[t2, 3].should eq "<p>You…</p>" # off by 1
        Truncate[t2, 4].should eq "<p>You…</p>" # this is where 'You' should get to be included
        Truncate[t2, 8].should eq "<p>You…</p>" 
        Truncate[t2, 9].should eq "<p>You never</p>" # desired semantics? (no … inside strong?)
        Truncate[t2, 10].should eq "<p>You never<strong>…</strong></p>" # off by 1
        Truncate[t2, 12].should eq "<p>You never<strong>did…</strong></p>" 
        Truncate[t2, 15].should eq "<p>You never<strong>did…</strong></p>" # off by 1 ()
        Truncate[t2, 16].should eq "<p>You never<strong>did the</strong></p>" # desired semantics?
        Truncate[t2, 17].should eq "<p>You never<strong>did the<em>…</em></strong></p>"
        Truncate[t2, 23].should eq "<p>You never<strong>did the<em>Kenosha</em></strong></p>" # desired?
        Truncate[t2, 24].should eq "<p>You never<strong>did the<em>Kenosha</em>…</strong></p>"
        Truncate[t2, 25].should eq "<p>You never<strong>did the<em>Kenosha</em>…</strong></p>"
        Truncate[t2, 26].should eq "<p>You never<strong>did the<em>Kenosha</em>Kid</strong></p>" #desired semantics?
        
      end
    end
  end
  describe 'helpers' do

    describe '#Done' do

      it'returns false if len is positive' do
        Done[1].should eq false
      end

      it 'returns true if len is zero' do
        Done[0].should eq true
      end

      it 'returns true if len is negative' do
        Done[-1].should eq true
      end
    end

    describe '#IsLeaf' do

      it'returns true if a node is a Leaf' do
        IsLeaf[Leaf['foo']].should be true
      end

      it'returns true if a node is a Leaf' do
        IsLeaf[Branch['foo', []]].should be false
      end
    end

    describe '#TextLen' do

      it 'returns the length of text in a Leaf' do
        TextLen[Leaf['Eat the rich']].should eq 12
      end
    end
  end
end
