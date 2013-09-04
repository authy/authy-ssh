#!/usr/bin/env ruby

require './helpers'

authy_ssh("update") do |stdin, stdout|
  print "Run update without root"
  if read_until(stdout, /root permissions are required to run this command/i)
    green " [OK]"
  else
    red " [FAILED]"
  end
end

FileUtils.cp(AUTHY_SCRIPT, "#{AUTHY_SCRIPT}.backup")
mtime = File.stat(AUTHY_SCRIPT).mtime
authy_ssh("update", {}, true) do |stdin, stdout|
  print "Updating the file"

  if read_until(stdout, /Do you want to overwrite .*\?/)
    stdin.puts "y"
  end

  if read_until(stdout, /Now type authy-ssh test/)
    new_mtime = File.stat(AUTHY_SCRIPT).mtime
    if new_mtime > mtime
      green " [OK]"
    else
      red " [FAILED]"
    end
  end
end
FileUtils.mv("#{AUTHY_SCRIPT}.backup", AUTHY_SCRIPT)

FileUtils.cp(AUTHY_SCRIPT, "#{AUTHY_SCRIPT}.backup")
mtime = File.stat(AUTHY_SCRIPT).mtime
authy_ssh("update", {}, true) do |stdin, stdout|
  print "Rejecting update"

  if read_until(stdout, /Do you want to overwrite .*\?/)
    stdin.puts "n"
  end

  if read_until(stdout, /Authy SSH was not updated./)
    new_mtime = File.stat(AUTHY_SCRIPT).mtime
    if new_mtime == mtime
      green " [OK]"
    else
      red " [FAILED]"
    end
  end
end
FileUtils.mv("#{AUTHY_SCRIPT}.backup", AUTHY_SCRIPT)

