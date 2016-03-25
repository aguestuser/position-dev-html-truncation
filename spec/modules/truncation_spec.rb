# coding: utf-8
require 'truncation'
include Truncation

RSpec.describe Truncation do

  describe '#Truncate' do

    it 'satisfies the conditions of this coding challenge' do
      Truncate["Hello there!", 7].should eq "Hello…"
      Truncate["<strong>Hello there!</strong>", 7].should eq "<strong>Hello…</strong>"
      Truncate["Hello <strong>there!</strong>", 7].should eq "Hello…"
    end
    
    it 'truncates a string to a specified length, eliding at word breaks' do

      str = "<p>You never<strong> did the <em> Kenosha</em>Kid</strong>. "

      Truncate[str, 1].should eq "…"
      Truncate[str, 3].should eq "…"

      Truncate[str, 4].should eq "You…"
      Truncate[str, 9].should eq "You…"

      Truncate[str, 10].should eq "You never…"
      Truncate[str, 12].should eq "You never…" 

      Truncate[str, 14].should eq "You never<strong> did…</strong>"
      Truncate[str, 17].should eq "You never<strong> did…</strong>"

      Truncate[str, 18].should eq "You never<strong> did the…</strong>"
      
      Truncate[str, 19].should eq "You never<strong> did the…</strong>"
      Truncate[str, 26].should eq "You never<strong> did the…</strong>"

      Truncate[str, 27].should eq "You never<strong> did the <em> Kenosha</em>…</strong>"
      Truncate[str, 29].should eq "You never<strong> did the <em> Kenosha</em>…</strong>"

      Truncate[str, 30].should eq "You never<strong> did the <em> Kenosha</em>Kid</strong>…"

      Truncate[str, 31].should eq "You never<strong> did the <em> Kenosha</em>Kid</strong>.…"
      Truncate[str, 32].should eq "You never<strong> did the <em> Kenosha</em>Kid</strong>. "
    end
  end

  describe '#Format' do

    it 'strips enclosing <p> tags from a string' do
      Format['<p>Eat the rich</p>'].should eq 'Eat the rich'
    end

    it 'does not strip <p> tags inside a string' do
      Format['Eat<p> the </p>rich'].should eq 'Eat<p> the </p>rich'
    end
  end
end
