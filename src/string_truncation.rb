# coding: utf-8
module StringTruncation

  SpaceOffset = 1

  ## MAIN FUNCTION ##

  # String -> String
  TruncateStr = lambda do |str, len|
    Detokenize[TruncateTokens[ParseTokens[str], len]]
  end

  ## HELPER FUNCTIONS ##

  ## parse step ##

  # String -> [String]
  ParseTokens = -> (str) { OffsetSpaces[Tokenize[str], str] }

  # String -> [String]
  Tokenize = -> str { str.split }

  # ([String], String) -> [String]
  OffsetSpaces = lambda do |tokens, str|
    OffsetTrailingSpace[*OffsetLeadingSpace[tokens, str]].first
  end
  
  # ([String], String) -> [String]
  OffsetLeadingSpace = lambda do |tokens, str|
    str[0] == ' ' ? 
      [[''] + tokens, str] :
      [tokens, str]
  end
  
  # ([String]) -> [String]
  OffsetTrailingSpace = lambda do |tokens, str|
    str[-1] == ' ' ?
      [tokens + [''], str] :
      [tokens, str]
  end

  ## compute step ##
  
  # ([String], Int) -> [String]
  TruncateTokens = lambda do |strs, len|
    hd, tl = [strs[0], strs[1..-1]]
    if hd.nil? then []
    elsif hd.length >= len then ["…"]
    else [hd] + TruncateTokens[tl, len - (hd.length + SpaceOffset)]
    end
  end

  ## pretty-print step ##

  # [String] -> String
  Detokenize = -> tokens { MaybeSquish[tokens].join(" ") }

  # [String] -> String
  MaybeSquish = -> tokens { AreTruncated[tokens] ? Squish[tokens] : tokens }

  # [String] -> Boolean
  AreTruncated = -> tokens { tokens[-1] == "…" && tokens.length > 1 }

  # [String] -> [String]
  Squish = -> tokens { tokens[0..-3] + [tokens[-2..-1].join('')] }

end
