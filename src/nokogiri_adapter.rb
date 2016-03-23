['nokogiri', 'tree'].each(&method(:require))

module NokogiriAdapter
  include Tree, Nokogiri

  # String -> Nokogiri::HTML::Document
  ParseBody = -> str { Nokogiri::HTML(str).children[1].children[0].children[0] }

  # String -> Tree::Branch
  ParseTree = lambda do |str|
    ParseTreeFromNode[ParseBody[str]]
  end
  
  # Nokogiri::HTML::Element -> Tree::Branch
  ParseTreeFromNode = lambda do |node|
    node.children.empty? ?      
      Leaf[node.text] :
      Branch[node.name, node.children.map(&ParseTreeFromNode)]
  end
end
