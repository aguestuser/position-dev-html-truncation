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
      it 'appends elipsis to string' do 
        Truncate[str, 10].should eq 'Eat the rich...'
      end
    end

    context 'string length is greater than target length' do
      it 'truncates string and appends elipsis at word break' do
        Truncate[str, 9].should eq 'Eat the rich...'
        Truncate[str, 7].should eq 'Eat the rich...'
        Truncate[str, 6].should eq 'Eat the...'
        Truncate[str, 4].should eq 'Eat the...'
        Truncate[str, 3].should eq 'Eat...'
        Truncate[str, 1].should eq 'Eat...'
      end
    end

    context 'string length is zero' do
      it 'returns an empty string'do
        Truncate['', 20].should eq ''
      end
    end

    context 'target length is zero' do
      it 'returns an empty string'do
        Truncate[str, 0].should eq ''
      end
    end

    context 'both string and target length are zero' do
      it 'returns an empty string'do
        Truncate[str, 0].should eq ''
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

      it 'detokenizes an array of strings into a string' do
        Detokenize[["Hello,", "world!"]].should eq "Hello, world!"
      end
    end

    describe '#MaybeTruncate' do

      context 'string is longer than target length' do
        it 'appends an elipsis' do 
          MaybeTruncate["hello", 4].should eq "hello..."
        end
      end

      context 'string is same length as target lenght' do
        it 'appends an elipsis' do
          MaybeTruncate["hello", 5].should eq "hello..."
        end
      end

      context 'string is shorter than target length' do
        it 'returns the string' do
          MaybeTruncate["hello", 6].should eq "hello"
        end
      end
    end

    describe '#TruncateTokens' do 

      tokens = ['Eat', 'the', 'rich']

      describe 'happy path' do

        context 'token lenghts sum to less than target length' do
          it 'returns tokens without mutating them' do 
            TruncateTokens[tokens, 50].should eq tokens
          end
        end

        context 'token lengths sum to target length' do
          it 'appends elipsis to last token' do
            TruncateTokens[tokens, 10].should eq ['Eat', 'the', 'rich...']
          end
        end

        context 'token lenghts sum to greater than target length' do
          it 'appends elipsis to token at which sumation reaches target, discards remaining tokens' do
            TruncateTokens[tokens, 9].should eq ['Eat', 'the', 'rich...']
            TruncateTokens[tokens, 7].should eq ['Eat', 'the', 'rich...']
            TruncateTokens[tokens, 6].should eq ['Eat', 'the...']
            TruncateTokens[tokens, 4].should eq ['Eat', 'the...']
            TruncateTokens[tokens, 3].should eq ['Eat...']
            TruncateTokens[tokens, 1].should eq ['Eat...']
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
          it 'returns an empty array' do 
            TruncateTokens[tokens, 0].should eq []
          end
        end
      end
    end
  end
end
