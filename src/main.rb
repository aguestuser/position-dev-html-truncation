#!/usr/bin/env ruby
$: << './modules'
require 'truncation'

class Main
  include Truncation

  # () -> ()
  Run = -> () { puts(Truncate[*ARGV[0..1]])}[]

end
