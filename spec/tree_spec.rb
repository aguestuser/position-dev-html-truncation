require 'tree'
include Tree

RSpec.describe Tree do

  describe Leaf do

    it 'has a value field' do
      Leaf.members.should eq [:value]
    end

    it 'constructs a Leaf from a value' do
      l = Leaf['foo']
      l.value.should eq 'foo'
    end

    it 'can use `new` or `[]` syntax for construction' do
      Leaf['foo'].should eq Leaf.new('foo')
    end

    it 'tests for hash equality' do
      Leaf['foo'].should eq Leaf['foo']
    end

    it 'has no children' do
      Leaf.new('foo').members.should_not include :children
    end
  end

  describe Branch do

    it 'has label and children fields' do
      Branch.members.should eq [:label, :children]
    end

    it 'tests for hash equality' do
      Branch['foo', [Leaf['bar'], Leaf['baz']]].should eq(
      Branch['foo', [Leaf['bar'], Leaf['baz']]])
    end

    it 'constructs a Branch from label and children Leafs' do

      root =
        Branch['root', [
          Leaf['foo'],
          Branch['child', [
            Leaf['bar'],
            Leaf['baz']
          ]],
        ]]

      l1, l2, l3 = [Leaf['foo'], Leaf['bar'], Leaf['baz']]
      child = Branch['child', [l2, l3]]
      root_ = Branch['root', [l1, child]]

      root.should eq root_
    end
  end
end
