#!/usr/bin/env ruby

require 'open3'
require 'timeout'

command = "bash #{File.expand_path("../authy-ssh-test", __FILE__)}"
ENV["DEBUG_AUTHY"] = "1"

puts command

def read_until(pipe, regexp)
  data = ""
  Timeout.timeout(10) do
    1024.times do
      read_data = pipe.read(1)
      break if read_data.nil?

      data << read_data
      if data =~ regexp
        return true
      end
    end
  end

  puts "\n---------"
  puts "\t\tFailed to match #{regexp} in #{data}"
  puts "---------"
  return false
rescue Timeout::Error
  puts "\n---------"
  puts "\t\tRead did timeout, current data is: #{data}"
  puts "---------"
  return false
end

Open3.popen2e("#{command} login") do |stdin, stdout, wait|
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

Open3.popen2e("#{command} login") do |stdin, stdout, wait|
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


Open3.popen2e("#{command} login") do |stdin, stdout, wait|
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




