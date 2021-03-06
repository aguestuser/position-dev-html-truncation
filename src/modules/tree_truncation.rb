# coding: utf-8
['tree', 'string_truncation'].each(&method(:require))

module TreeTruncation
  include Tree, StringTruncation

  ## MAIN FUNCTIONS ##

  # (Either[Branch,Leaf], Int) ->  String
  TruncateTree = lambda do |node, len|
    IsLeaf[node] ?
      TruncateLeaf[node.value, len] :
      TruncateBranch[node, len]
  end

  # (Leaf, Int) -> String
  TruncateLeaf = lambda do |lf, len|
    Done[len] ? '' : StringTruncation::TruncateStr[lf.value, len]
  end

  # (Branch, Int) -> String
  TruncateBranch = lambda do |br, len|
    Done[len] ? '' : MaybeWrap[TruncateBranchContents[br, len], br.label]
  end

  # String -> String
  MaybeWrap = -> (str, tag) { str ==  '…' ? '…' : "<#{tag}>#{str}</#{tag}>" }

  # (Branch, Int) -> String
  TruncateBranchContents = lambda do |br, len|
    br.children.reduce(['', len]){ |acc, child|
      str, len_ = acc
      trunc = IsLeaf[child] ? TruncateLeaf : TruncateBranch
      [ str + trunc[ child, len_ ], len_ - TextLen[child] ]
    }[0]
  end
  
  ## HELPERS ##

  # Int -> Boolean
  Done = -> (len) { len <= 0 }
  
  # (Either[Branch,Leaf]) -> Boolean
  IsLeaf = -> node { node.class == Leaf }

  # (Either[Branch,Leaf]) -> Int
  TextLen = lambda do |node|
    IsLeaf[node] ?
      node.value.size :
      node.children.reduce(0){ |acc, child| acc + TextLen[child] }
  end
  
  # NOTE:
  # * Calling `TextLen` on a Branch on line 34 blows up the Big O of this program.
  # * Before that call, (I think?) it runs in O(m+n), where m is the number of HTML tags
  #   and n is the number of characters in the string.
  # * After the call, it runs in O(m^2+n) -- because for every m DOM nodes, we
  #   have to traverse O(m) DOM nodes to find the length of the text it contains.
  # * I can't really find a good way around this, as without this call, the running
  #   length of the reduction is discarded after a control flow passes from a recursive
  #   call to `TruncateBranchContents` back to the containing call to the same function
  
end
