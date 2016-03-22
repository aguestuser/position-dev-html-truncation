# coding: utf-8
require 'truncation'
include Truncation

RSpec.describe 'Truncation module'  do

  describe '#Truncate' do

    str = 'Eat the rich'
    
    context 'string length is less than target length' do
      it 'returns the string without mutating it' do
        Truncate[str, 100].should eq 'Eat the rich'
      end
    end

    context 'string length is equal to target length' do
      it 'returns the string without mutating it' do 
        Truncate[str, 12].should eq 'Eat the rich'
      end
    end

    context 'string length is greater than target length' do
      it 'truncates string and appends elipsis at word break' do
        Truncate[str, 11].should eq 'Eat the…'
        Truncate[str, 7].should eq 'Eat the…'
        Truncate[str, 6].should eq 'Eat…'
        Truncate[str, 3].should eq 'Eat…'
        Truncate[str, 2].should eq '…'
        Truncate[str, 1].should eq '…'
      end
    end

    context 'with empty string' do
      it 'returns an empty string'do
        Truncate['', 20].should eq ''
      end
    end

    context 'target length is zero' do
      it 'returns an elipsis' do
        Truncate[str, 0].should eq '…'
      end
    end

    context 'empty string and target length is zero' do
      it 'returns an elipsis' do
        Truncate[str, 0].should eq '…'
      end
    end
  end

  describe 'helper functions'do

    describe '#Tokenize' do

      it 'tokenizes a string into an array of strings' do
        Tokenize["Hi Austin"].should eq ["Hi", "Austin"]
      end
      
      it 'includes punctuation in tokens, son!' do
        Tokenize["Hello, world!"].should eq ["Hello,", "world!"]
      end
    end

    describe '#Detokenize' do

      context 'with no elipsis tokens' do
        it 'detokenizes an array of tokens into a string' do
          Detokenize[["Hello,", "world"]].should eq "Hello, world"
        end
      end

      context 'with an elipsis token in final position' do
        it 'concatenates last two tokens and detokenizes array of tokens into a string' do
          Detokenize[["Hello,", "world", "…"]].should eq "Hello, world…"
        end
      end

    end

    describe '#MaybeSquish' do

      context 'token array of more than one element' do

        context 'last token is `…`'  do
          it 'concatenates last two tokens and returns array with one less element' do 
            MaybeSquish[["hello", "world", "…"]].should eq ["hello", "world…"]
          end
        end

        context 'last token in an array is not `…`'  do
          it 'returns array identical to input' do 
            MaybeSquish[["hello", "world"]].should eq ["hello", "world"]
            MaybeSquish[["hello", "world", "!!!"]].should eq ["hello", "world", "!!!"]
          end
        end
      end

      context 'token array of only one element' do
        context 'last token is `…`'  do
          it 'concatenates last two tokens and returns array with one less element' do 
            MaybeSquish[["…"]].should eq ["…"]
          end
        end

        context 'last token in an array is not `…`'  do
          it 'returns array identical to input' do 
            MaybeSquish[["foo"]].should eq ["foo"]
          end
        end
      end
    end

    describe '#TruncateTokens' do 

      tokens = ['Eat', 'the', 'rich']

      describe 'happy path' do

        context 'token lenghts and space offsets sum to less than target length' do
          it 'returns tokens without mutating them' do 
            TruncateTokens[tokens, 50].should eq tokens
          end
        end

        context 'token lengths and space offsets sum to target length' do
          it 'returns tokens without mutating them' do
            TruncateTokens[tokens, 12].should eq tokens
            
          end
        end

        context 'token lenghts and space offsets sum to greater than target length' do
          it 'replaces token at which sumation reaches target with elipsis, discards remaining tokens' do
            TruncateTokens[tokens, 11].should eq ['Eat', 'the', '…']
            TruncateTokens[tokens, 7].should eq ['Eat', 'the', '…']
            TruncateTokens[tokens, 6].should eq ['Eat', '…']
            TruncateTokens[tokens, 3].should eq ['Eat', '…']
            TruncateTokens[tokens, 2].should eq ['…']
            TruncateTokens[tokens, 0].should eq ['…']
          end
        end
      end

      describe 'corner cases' do

        context 'tokens are an empty array' do
          it 'returns an empty array' do 
            TruncateTokens[[], 20].should eq []
          end
        end
        
        context 'target length is 0' do
          it 'returns an array with single elipsis token' do 
            TruncateTokens[tokens, 0].should eq ['…']
          end
        end

        context 'target length is 0 and tokens are empty array' do
          it 'returns an array with single elipsis token' do 
            TruncateTokens[tokens, 0].should eq ['…']
          end
        end
      end
    end
  end
end
