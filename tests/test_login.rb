#!/usr/bin/env ruby

require './helpers'

authy_ssh("login") do |stdin, stdout|
  if read_until(stdout, /Authy Token/)
    print "Sending invalid token: 1234"
    stdin.puts "1234"
  end

  if read_until(stdout, /You have to enter a valid token/i)
    green " [OK]"
  else
    red " [FAILED]"
  end
end

authy_ssh("login") do |stdin, stdout|
  if read_until(stdout, /Authy Token/)
    print "Sending invalid token: 123456"
    stdin.puts "123456"
  end

  if read_until(stdout, /Invalid token/i)
    green " [OK]"
  else
    red " [FAILED]"
  end
end

authy_ssh("login", "mode" => "test", "authy_token" => "32|21") do |stdin, stdout|
  if read_until(stdout, /Authy Token/)
    print "Sending invalid token: 0000000/12w#-}A$Rf s'Q{3A"
    stdin.puts "0000000/12w#-}A$Rf s'Q{3A"
  end

  if read_until(stdout, /Logging 2 with 0000000123 in login mode./i)
    green " [OK]"
  else
    red " [FAILED]"
  end
end

authy_ssh("login", "AUTHY_TOKEN" => "323|212") do |stdin, stdout|
  print "Loging in using the AUTHY_TOKEN env var"
  if read_until(stdout, /Logging 2 with 323212 in login mode./i)
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

  if read_until(stdout, /SMS token was sent/i)
    green " [OK]"
  else
    red " [FAILED]"
  end
end

