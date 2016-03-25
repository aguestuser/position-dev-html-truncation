#!/usr/bin/env ruby
$: << './modules'
require 'truncation'

class Main
  include Truncation

  # () -> ()
  Run = -> () { puts(Truncate[Str, Len])}[]

end
