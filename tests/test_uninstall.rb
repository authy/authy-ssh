#!/usr/bin/env ruby

require './helpers'

authy_ssh("uninstall") do |stdin, stdout|
  if read_until(stdout, /root permisisons are required to run this command/i)
    print "Run uninstall without root"
    green " [OK]"
  else
    red " [FAILED]"
  end
end

authy_ssh("uninstall", {}, true) do |stdin, stdout|
  print "Run uninstall"
  if read_until(stdout, /Authy SSH was uninstalled/i)
    green " [OK]"
  else
    red " [FAILED]"
  end
end