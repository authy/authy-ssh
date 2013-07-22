#!/usr/bin/env ruby

require './helpers'

authy_ssh("login") do |stdin, stdout|
  if read_until(stdout, /Authy Token/)
    print "Sending invalid token: 1234"
    stdin.puts "1234"
  end

  if read_until(stdout, /Invalid token/i)
    green " [OK]"
  else
    red " [FAILED]"
  end
end

authy_ssh("login") do |stdin, stdout|
  if read_until(stdout, /Authy Token/)
    print "Sending invalid token: 1-}2$34 5'6{7"
    stdin.puts "1-}2$34 5'6{7"
  end

  if read_until(stdout, /Logging 2 with 1234567 in login mode./i)
    green " [OK]"
  else
    red " [FAILED]"
  end
end

authy_ssh("login") do |stdin, stdout|
  if read_until(stdout, /Authy Token/)
    print "Sending valid token: 0000000"
    stdin.puts "0000000"
  end

  if read_until(stdout, /Logged in for testing/i)
    green " [OK]"
  else
    red " [FAILED]"
  end
end

authy_ssh("login") do |stdin, stdout|
  if read_until(stdout, /Authy Token/)
    print "Sending invalid token: "
    stdin.puts ""
  end

  if read_until(stdout, /You have to enter only digits/i)
    green " [OK]"
  else
    red " [FAILED]"
  end
end

authy_ssh("login") do |stdin, stdout|
  if read_until(stdout, /Authy Token/)
    print "Request SMS"
    stdin.puts "sms"
  end

  if read_until(stdout, /SMS is not enabled on Sandbox accounts./i)
    green " [OK]"
  else
    red " [FAILED]"
  end
end

