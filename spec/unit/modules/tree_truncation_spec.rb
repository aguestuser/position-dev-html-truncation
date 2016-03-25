# coding: utf-8
require 'tree_truncation'
include TreeTruncation

RSpec.describe TreeTruncation do

  describe'main function' do

    describe '#Truncate' do

      context 'no leading or trailing spaces' do
        tree = 
          Branch['p', [
            Leaf['You never'],
            Branch['strong', [
              Leaf['did the'],
              Branch['em', [
                Leaf['Kenosha']]],
              Leaf['Kid']]],
            Leaf['.']]]

        context 'tree contains less characters than the limit' do
          it 'does not mutate the tree' do
            Truncate[tree, 28].should eq "<p>You never<strong>did the<em>Kenosha</em>Kid</strong>.</p>"
          end
        end

        context 'tree contains an equal number of characters as the limit' do
          it 'truncates the last word in the tree' do
            Truncate[tree, 27].should eq "<p>You never<strong>did the<em>Kenosha</em>Kid</strong>…</p>"
          end
        end

        context 'character limit is 0' do
          it 'returns an empty string'do
            Truncate[tree, 0].should eq ''
          end
        end

        context 'characters in tree reach or exceed limit' do

          it 'truncates the tree at the last word break before the limit' do
            
            Truncate[tree, 1].should eq "<p>…</p>" # 
            Truncate[tree, 3].should eq "<p>…</p>"

            Truncate[tree, 4].should eq "<p>You…</p>"
            Truncate[tree, 9].should eq "<p>You…</p>"

            Truncate[tree, 10].should eq "<p>You never<strong>…</strong></p>"
            Truncate[tree, 12].should eq "<p>You never<strong>…</strong></p>" 

            Truncate[tree, 13].should eq "<p>You never<strong>did…</strong></p>"
            Truncate[tree, 16].should eq "<p>You never<strong>did…</strong></p>"

            Truncate[tree, 17].should eq "<p>You never<strong>did the<em>…</em></strong></p>"
            Truncate[tree, 23].should eq "<p>You never<strong>did the<em>…</em></strong></p>"

            Truncate[tree, 24].should eq "<p>You never<strong>did the<em>Kenosha</em>…</strong></p>"
            Truncate[tree, 26].should eq "<p>You never<strong>did the<em>Kenosha</em>…</strong></p>"

            Truncate[tree, 27].should eq "<p>You never<strong>did the<em>Kenosha</em>Kid</strong>…</p>"
          end
        end
      end


      context 'leading and trailing spaces' do
        tree = 
          Branch['p', [
            Leaf['You never'],
            Branch['strong', [
              Leaf[' did the '],
              Branch['em', [
                Leaf[' Kenosha']]],
              Leaf['Kid']]],
            Leaf['. ']]]

        context 'tree contains less characters than the limit' do
          it 'does not mutate the tree' do
            Truncate[tree, 32].should(
              eq("<p>You never<strong> did the <em> Kenosha</em>Kid</strong>. </p>"))
          end
        end

        context 'tree contains an equal number of characters as the limit' do
          it 'truncates the last word in the tree' do
            Truncate[tree, 31].should(
              eq("<p>You never<strong> did the <em> Kenosha</em>Kid</strong>.…</p>"))
          end
        end

        context 'characters in tree reach or exceed limit' do

          it 'truncates the tree at the last word break before the limit' do
            
            Truncate[tree, 1].should eq "<p>…</p>"
            Truncate[tree, 3].should eq "<p>…</p>"

            Truncate[tree, 4].should eq "<p>You…</p>"
            Truncate[tree, 9].should eq "<p>You…</p>"

            Truncate[tree, 10].should eq "<p>You never<strong>…</strong></p>"
            Truncate[tree, 12].should eq "<p>You never<strong>…</strong></p>" 

            Truncate[tree, 14].should eq "<p>You never<strong> did…</strong></p>"
            Truncate[tree, 17].should eq "<p>You never<strong> did…</strong></p>"

            Truncate[tree, 18].should eq "<p>You never<strong> did the…</strong></p>"
            
            Truncate[tree, 19].should eq "<p>You never<strong> did the <em>…</em></strong></p>"
            Truncate[tree, 26].should eq "<p>You never<strong> did the <em>…</em></strong></p>"

            Truncate[tree, 27].should eq "<p>You never<strong> did the <em> Kenosha</em>…</strong></p>"
            Truncate[tree, 29].should eq "<p>You never<strong> did the <em> Kenosha</em>…</strong></p>"

            Truncate[tree, 30].should eq "<p>You never<strong> did the <em> Kenosha</em>Kid</strong>…</p>"

            Truncate[tree, 31].should eq "<p>You never<strong> did the <em> Kenosha</em>Kid</strong>.…</p>"
          end
        end
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
