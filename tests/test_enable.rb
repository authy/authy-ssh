#!/usr/bin/env ruby

require './helpers'

authy_ssh("enable #{ENV["USER"]}") do |stdin, stdout|
  print "Run command without root"
  if read_until(stdout, /root permissions are required to run this command/i)
    green " [OK]"
  else
    red " [FAILED]"
  end
end

authy_ssh("enable doe123 test@authy.com 1 111-111-1111", {}, true) do |stdin, stdout|

  if read_until(stdout, /Do you want to enable this user/i)
    stdin.puts "y"
  end

  if read_until(stdout, /was not found in your system/i)
    print "User doesn't exist in the system"
    green " [OK]"
  else
    red " [FAILED]"
  end
end

authy_ssh("enable #{ENV["USER"]} 'test;;;@authy' 1 111-111-1111", {}, true) do |stdin, stdout|

  if read_until(stdout, /Do you want to enable this user/i)
    stdin.puts "y"
  end

  if read_until(stdout, /Email is invalid/i)
    print "Sending an invalid email: test;;;@authy"
    green " [OK]"
  else
    red " [FAILED]"
  end
end

authy_ssh("enable #{ENV["USER"]} test@authy.com 0 '111;111;;;1111'", {}, true) do |stdin, stdout|

  if read_until(stdout, /Do you want to enable this user/i)
    stdin.puts "y"
  end

  if read_until(stdout, /country_code":"is invalid/i)
    green " [OK]"
  else

    red " [FAILED]"
  end
end

authy_ssh("enable #{ENV["USER"]} 'test;;;@authy.com' 1 11145a", {}, true) do |stdin, stdout|

  if read_until(stdout, /test@authy.com/i)
    stdin.puts "y"
  end

  if read_until(stdout, /Cellphone is invalid/i)
    print "Sending an invalid cellphone number: 11145a"
    green " [OK]"
  else
    red " [FAILED]"
  end
end

authy_ssh("enable #{ENV["USER"]} 'test;;;@authy.com' '1|}+)(&%' '111;|};111#-/:1111'", {}, true) do |stdin, stdout|

  if read_until(stdout, /Do you want to enable this user/i)
    stdin.puts "y"
  end

  if read_until(stdout, /User was registered/i)
    print "Should escape the invalid characters and register the user"
    green " [OK]"
  else
    red " [FAILED]"
  end
end

authy_ssh("enable #{ENV["USER"]} 'test;;;@authy.com' '1|}+)(&%' '111;|};111#-/:1111' aaa", {}, true) do |stdin, stdout|

  if read_until(stdout, /Do you want to enable this user/i)
    stdin.puts "y"
  end

  if read_until(stdout, /grace-time is invalid/i)
    print "Setting an invalid grace-time: aaa"
    green " [OK]"
  else
    red " [FAILED]"
  end
end

authy_ssh("enable #{ENV["USER"]} test@authy.com 0 111-111-1111 -2", {}, true) do |stdin, stdout|

  if read_until(stdout, /Do you want to enable this user/i)
    stdin.puts "y"
  end

  if read_until(stdout, /grace-time is invalid/i)
    print "Setting an invalid grace-time: -2"
    green " [OK]"
  else
    red " [FAILED]"
  end
end
