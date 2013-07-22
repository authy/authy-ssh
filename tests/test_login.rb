#!/usr/bin/env ruby

require 'open3'
require 'timeout'
require './helpers'

authy_ssh("login") do |stdin, stdout|
  if read_until(stdout, /Authy Token/)
    print "Sending invalid token: 1234"
    stdin.puts "1234"
  end

  if read_until(stdout, /Invalid token/i)
    puts " [OK]"
  else
    puts " [FAILED]"
  end
end

authy_ssh("login") do |stdin, stdout|
  if read_until(stdout, /Authy Token/)
    print "Sending invalid token: 1-}2$34 5'6{7"
    stdin.puts "1-}2$34 5'6{7"
  end

  if read_until(stdout, /Logging \d+ with 1234567 in login mode./i)
    puts " [OK]"
  else
    puts " [FAILED]"
  end
end

authy_ssh("login") do |stdin, stdout|
  if read_until(stdout, /Authy Token/)
    print "Sending valid token: 0000000"
    stdin.puts "0000000"
  end

  if read_until(stdout, /Logged in for testing/i)
    puts " [OK]"
  else
    puts " [FAILED]"
  end
end

authy_ssh("login") do |stdin, stdout|
  if read_until(stdout, /Authy Token/)
    print "Sending invalid token: "
    stdin.puts ""
  end

  if read_until(stdout, /You have to enter only digits/i)
    puts " [OK]"
  else
    puts " [FAILED]"
  end
end

authy_ssh("login") do |stdin, stdout|
  if read_until(stdout, /Authy Token/)
    print "Request SMS"
    stdin.puts "sms"
  end

  if read_until(stdout, /SMS is not enabled on Sandbox accounts./i)
    puts " [OK]"
  else
    puts " [FAILED]"
  end
end

authy_ssh("update") do |stdin, stdout|
  print "Run update without root"
  if read_until(stdout, /root permisisons are required to run this command/i)
    puts " [OK]"
  else
    puts " [FAILED]"
  end
end

