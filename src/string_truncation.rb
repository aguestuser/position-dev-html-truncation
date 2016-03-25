# coding: utf-8
module StringTruncation

  SpaceOffset = 1
  
  # String -> [String]
  Tokenize = -> str { str.split }

  # [String] -> String
  Detokenize = -> words { MaybeSquish[words].join(" ") }

  # [String] -> String
  MaybeSquish = lambda do |words|
    words[-1] == "…" && words.length > 1 ? 
      words[0..-3] + [words[-2..-1].join('')] :
      words
  end

  # ([String], Int) -> [String]
  TruncateTokens = lambda do |strs, len|
    hd, tl = [strs[0], strs[1..-1]]
    if hd.nil? then []
    elsif hd.length > len then ["…"]
    else [hd] + TruncateTokens[tl, len - (hd.length + SpaceOffset)]
    end
  end

  # String -> String
  TruncateStr = -> (str, len) { Detokenize[TruncateTokens[Tokenize[str], len]] }

end
