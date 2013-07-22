#!/usr/bin/env ruby

require './helpers'

authy_ssh("version") do |stdin, stdout|
  print "Print authy-ssh version"
  if read_until(stdout, /Authy SSH v\d.\d/i)
    green " [OK]"
  else
    red " [FAILED]"
  end
end