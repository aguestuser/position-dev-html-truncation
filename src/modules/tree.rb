module Tree
  Leaf = Struct.new(:value)
  Branch = Struct.new(:label, :children)
end
