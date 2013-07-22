#!/usr/bin/env ruby

require './helpers'

authy_ssh("update") do |stdin, stdout|
  print "Run update without root"
  if read_until(stdout, /root permisisons are required to run this command/i)
    puts " [OK]"
  else
    puts " [FAILED]"
  end
end

