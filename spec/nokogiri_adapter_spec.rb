['nokogiri_adapter', 'nokogiri', 'tree'].each(&method(:require))
include NokogiriAdapter, Nokogiri, Nokogiri::HTML, Nokogiri::XML, Tree

RSpec.describe NokogiriAdapter do

  k_str = "You never <strong>did the <em>Kenosha</em> Kid</strong>."
  count_children = -> node { node.children.count }
  
  describe Nokogiri::HTML do

    it 'parses an HTML string to an imperative Nokogiri tree that is difficult to reason about' do
      
      doc1 = Nokogiri::HTML(k_str)
      doc2 = Nokogiri::HTML::Builder.new { |doc|
        doc.html {
          doc.body {
            doc.p {
              doc.text 'You never '
              doc.strong {
                doc.text 'did the '
                doc.em {
                  doc.text 'Kenosha'
                }
                doc.text ' Kid'
              }
              doc.text '.'
            }
          }
        }
      }.doc

      # check this out...
      doc1.should_not eq doc2
      # ^-- sucks, huh? wouldn't testing for hash equality instead of object equality be nice?
      # instead we have to do this to place our tree under test...
      
      roots = [doc1, doc2]
      
      roots.map(&:class).should all ( eq HTML::Document )
      roots.map(&count_children).should all ( eq 2 )

      node0s = roots.map{ |r| r.children[0] }

      node0s.map(&:class).should all (eq XML::DTD )
      node0s.map(&count_children).should all ( eq 0 )
      
      node1s = roots.map { |r| r.children[1] }

      node1s.map(&:class).should all ( eq XML::Element )
      node1s.map(&count_children).should all ( eq 1 )
      node1s.map(&:name).should all ( eq 'html' )
      
        node10s = node1s.map { |n| n.children[0] }

        node10s.map(&:class).should all ( eq XML::Element )
        node10s.map(&count_children).should all ( eq 1 )
        node10s.map(&:name).should all ( eq 'body' )
        
          node100s = node10s.map { |n| n.children[0] }

          node100s.map(&:class).should all ( eq XML::Element )
          node100s.map(&count_children).should all ( eq 3 )
          node100s.map(&:name).should all ( eq 'p' )
      
            node1000s = node100s.map { |n| n.children[0] }

            node1000s.map(&:class).should all ( eq XML::Text )
            node1000s.map(&count_children).should all ( eq 0 )
            node1000s.map(&:name).should all ( eq 'text' )
            node1000s.map(&:text).should all ( eq 'You never ' )

            node1001s = node100s.map { |n| n.children[1] }

            node1001s.map(&:class).should all ( eq XML::Element )
            node1001s.map(&count_children).should all ( eq 3 )
            node1001s.map(&:name).should all ( eq 'strong' )
      
              node10010s = node1001s.map { |n| n.children[0] }

              node10010s.map(&:class).should all ( eq XML::Text )
              node10010s.map(&count_children).should all ( eq 0 )
              node10010s.map(&:name).should all ( eq 'text' )
              node10010s.map(&:text).should all ( eq 'did the ' )

              node10011s = node1001s.map { |n| n.children[1] }

              node10011s.map(&:class).should all ( eq XML::Element )
              node10011s.map(&count_children).should all ( eq 1 )
              node10011s.map(&:name).should all ( eq 'em' )

              node10012s = node1001s.map { |n| n.children[2] }

              node10012s.map(&:class).should all ( eq XML::Text )
              node10012s.map(&count_children).should all ( eq 0 )
              node10012s.map(&:name).should all ( eq 'text' )
              node10012s.map(&:text).should all ( eq ' Kid' )

            node1002s = node100s.map { |n| n.children[2] }

            node1002s.map(&:class).should all ( eq XML::Text )
            node1002s.map(&count_children).should all ( eq 0 )
            node1002s.map(&:name).should all ( eq 'text' )
            node1002s.map(&:text).should all ( eq '.' )

      # ^-- what a mouthful!!!
      # wouldn't it be nice if we had something cleaner?  perhaps....            
    end
  end

  describe ParseTree do

    declarative_tree = 
      Branch['p', [
        Leaf['You never '],
        Branch['strong', [
          Leaf['did the '],
          Branch['em', [
            Leaf['Kenosha']]],
          Leaf[' Kid']]],
        Leaf['.']]]
    # ^--- just about as terse as the Nokogiri builder, and no mutation!

    it 'parses HTML into a declarative tree that is easy to reason about' do
      ParseTree[k_str].should eq declarative_tree
      # ^-- now we can inspect for equality in one line! yay!
    end

    describe 'helpers' do

      describe ParseBody do

        it 'extracts the body from a Nokogiri tree' do
          node = ParseBody[k_str]

          node.class.should eq XML::Element
          node.name.should eq 'p'
          node.parent.name.should eq 'body'
          count_children[node].should eq 3
        end
      end

      describe ParseTreeFromNode do

        it 'parses the contents of a Nokogiri `body` Element into a `Branch`' do
          ParseTreeFromNode[ParseBody[k_str]].should eq declarative_tree
        end
      end
    end
  end
end
