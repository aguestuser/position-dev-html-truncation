# coding: utf-8
require 'string_truncation'
include StringTruncation

RSpec.describe StringTruncation do

  describe 'main function' do

    describe "#TruncateStr" do
      
      context 'happy path' do
        
        str = 'Eat the rich'
        
        context 'string length is less than character limit' do
          it 'returns the string without mutating it' do
            TruncateStr[str, 13].should eq 'Eat the rich'
          end
        end

        context 'string length is equal to character limit' do
          it 'truncates the last word of the string' do 
            TruncateStr[str, 12].should eq 'Eat the…'
          end
        end

        context 'string length is greater than character limit' do
          it 'truncates string and appends elipsis at last word break before limit reached' do

            TruncateStr[str, 1].should eq '…'
            TruncateStr[str, 3].should eq '…'

            TruncateStr[str, 4].should eq 'Eat…'
            TruncateStr[str, 7].should eq 'Eat…'

            TruncateStr[str, 8].should eq 'Eat the…'
            TruncateStr[str, 11].should eq 'Eat the…'
          end
        end
      end

      context 'corner cases' do

        context 'empty string' do
          it 'returns an empty string'do
            TruncateStr['', 20].should eq ''
          end
        end

        context 'target length is zero' do
          it 'returns an elipsis' do
            TruncateStr['foobar', 0].should eq '…'
          end
        end

        context 'empty string and target length is zero' do
          it 'returns an empty string' do
            TruncateStr['', 0].should eq ''
          end
        end
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

        context 'token lenghts and space offsets sum to less than limit' do
          it 'returns tokens without mutating them' do 
            TruncateTokens[tokens, 13].should eq tokens
          end
        end

        context 'token lengths and space offsets sum to limit' do
          it 'replaces last token with elipsis' do
            TruncateTokens[tokens, 12].should eq ['Eat', 'the', '…']
          end
        end

        context 'token lenghts and space offsets sum to greater than limit' do
          it 'replaces token at which sumation reaches limit with elipsis, discards remaining tokens' do
            TruncateTokens[tokens, 0].should eq ['…']
            TruncateTokens[tokens, 3].should eq ['…']

            TruncateTokens[tokens, 4].should eq ['Eat', '…']
            TruncateTokens[tokens, 7].should eq ['Eat', '…']

            TruncateTokens[tokens, 8].should eq ['Eat', 'the', '…']
            TruncateTokens[tokens, 12].should eq ['Eat', 'the', '…']
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
