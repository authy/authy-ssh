#!/usr/bin/env ruby

require './helpers'

authy_ssh("install") do |stdin, stdout|
  print "Run install without root"
  if read_until(stdout, /root permisisons are required to run this command/i)
    green " [OK]"
  else
    red " [FAILED]"
  end
end

authy_ssh("install .", {}, true) do |stdin, stdout|
  if read_until(stdout, /Enter the Authy API key/i)
    print "Sending an empty API key"
    stdin.puts ""
  end

  if read_until(stdout, /you have entered a wrong API key/i)
    system("sudo rm authy-ssh")
    green " [OK]"
  else
    red " [FAILED]"
  end
end

authy_ssh("install .", {}, true) do |stdin, stdout|
  if read_until(stdout, /Enter the Authy API key/i)
    stdin.puts "0cd08abec2e9b9641e40e9470a7fc336"
  end

  if read_until(stdout, /type 1 or 2 to select the option/i)
    print "Select the option 1: Disable two factor authentication until api.authy.com is back"
    stdin.puts "1"
  end

  if read_until(stdout, /Restart the SSH server to apply changes/i)
    config_path = File.expand_path("../authy-ssh.conf", __FILE__)
    config = File.read(config_path)
    if config =~ /default_verify_action=disable/
      green " [OK]"
    else
      yellow " Option not configured"
    end
  else
    red " [FAILED]"
  end
  system("sudo rm authy-ssh authy-ssh.conf")
end

authy_ssh("install .", {}, true) do |stdin, stdout|
  if read_until(stdout, /Enter the Authy API key/i)
    stdin.puts "0cd08abec2e9b9641e40e9470a7fc336"
  end

  if read_until(stdout, /type 1 or 2 to select the option/i)
    print "Select the option 2: Don't allow logins until api.authy.com is back"
    stdin.puts "2"
  end

  if read_until(stdout, /Restart the SSH server to apply changes/i)
    config_path = File.expand_path("../authy-ssh.conf", __FILE__)
    config = File.read(config_path)
    if config =~ /default_verify_action=enforce/
      green " [OK]"
    else
      yellow " Option not configured"
    end
  else
    red " [FAILED]"
  end
  system("sudo rm authy-ssh authy-ssh.conf")
end

authy_ssh("install .", {}, true) do |stdin, stdout|
  if read_until(stdout, /Enter the Authy API key/i)
    stdin.puts "0cd08abec2e9b9641e40e9470a7fc336"
  end

  if read_until(stdout, /type 1 or 2 to select the option/i)
    print "Select an invalid option: 9"
    stdin.puts "9"
  end

  if read_until(stdout, /you have entered a invalid option/i)
    green " [ok]"
  else
    red " [FAILED]"
  end
  system("sudo rm authy-ssh")
end