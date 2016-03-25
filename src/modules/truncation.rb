# coding: utf-8
[
  'nokogiri_adapter',
  'tree_truncation'
].each(&method(:require))

module Truncation
  include NokogiriAdapter, TreeTruncation
  
  # (String, String) -> String
  Truncate = -> (html, len) { Format[TruncateTree[ParseTree[html], Integer(len)]] }

  # String -> String
  Format = lambda do |str|
    str_ = str[0..2] == '<p>' ? str[3..-1] : str
    str_.chomp('</p>')
  end
end
