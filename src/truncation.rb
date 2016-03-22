module Truncation

  ###########################################################
  #                                                         #
  # TODO:                                                   #
  #   ask a True Rubyist why CapitalizedConstants           #
  #   are the only way I can export lambdas from a module!  #
  #                                                         #
  ###########################################################
  
  # String -> [String]
  Tokenize = -> str { str.split }

  # [String] -> String
  Detokenize = -> words { words.join(" ") }

  # (String, Int) -> String
  MaybeTruncate = -> (str, len) { str.length >= len ? "#{str}..." : str }

  # ([String], Int) -> [String]
  TruncateTokens = lambda do |strs, len|
    head, tail = [strs[0], strs[1..-1]]
    if tail.nil?
      []
    elsif len <= 0
      [] + TruncateTokens[tail, len]
    else
      [MaybeTruncate[head, len]] + TruncateTokens[tail, len - head.length]
    end
  end

  # String -> String
  Truncate = -> (str, len) { Detokenize[TruncateTokens[Tokenize[str], len]] }

end
