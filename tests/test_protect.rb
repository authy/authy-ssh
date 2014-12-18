#!/usr/bin/env ruby

require './helpers'

authy_ssh("protect #{ENV["USER"]}") do |stdin, stdout|
  if read_until(stdout, /Enter your public ssh key/i)
    stdin.puts "#{SSH_KEY}"
  end

  if read_until(stdout, /Your country code/i)
    print "Sending an invalid country code: 0"
    stdin.puts "0"
  end

  if read_until(stdout, /Your cellphone/i)
    stdin.puts "123456"
  end

  if read_until(stdout, /Your email/i)
    stdin.puts "test@authy.com"
  end

  if read_until(stdout, /Do you want to enable this user/i)
    stdin.puts "y"
  end

  if read_until(stdout, /country_code":"is invalid/i)
    green " [OK]"
  else
    red " [FAILED]"
  end
end

authy_ssh("protect #{ENV["USER"]}") do |stdin, stdout|
  if read_until(stdout, /Enter your public ssh key/i)
    stdin.puts "#{SSH_KEY}"
  end

  if read_until(stdout, /Your country code/i)
    stdin.puts "1"
  end

  if read_until(stdout, /Your cellphone/i)
    print "Sending an invalid cellphone: 12345"
    stdin.puts "12345"
  end

  if read_until(stdout, /Your email/i)
    stdin.puts "test@authy.com"
  end

  if read_until(stdout, /Do you want to enable this user/i)
    stdin.puts "y"
  end

  if read_until(stdout, /Cellphone is invalid/i)
    green " [OK]"
  else
    red " [FAILED]"
  end
end

authy_ssh("protect #{ENV["USER"]}") do |stdin, stdout|
  if read_until(stdout, /Enter your public ssh key/i)
    stdin.puts "#{SSH_KEY}"
  end

  if read_until(stdout, /Your country code/i)
    stdin.puts "1"
  end

  if read_until(stdout, /Your cellphone/i)
    stdin.puts "123456"
  end

  if read_until(stdout, /Your email/i)
    print "Sending an invalid email: test@authy"
    stdin.puts "test@authy"
  end

  if read_until(stdout, /Do you want to enable this user/i)
    stdin.puts "y"
  end

  if read_until(stdout, /Email is invalid/i)
    green " [OK]"
  else
    red " [FAILED]"
  end
end
