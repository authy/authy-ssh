#!/usr/bin/env ruby

require 'open3'
require 'timeout'

command=File.expand_path("../../authy-ssh", __FILE__)
ENV["DEBUG_AUTHY"] = "1"

def read_until(pipe, regexp)
  data = ""
  Timeout.timeout(10) do
    50.times do
      data << pipe.read(10)

      if data =~ regexp
        return true
      end
    end
  end

  puts "---------"
  puts "Failed to match #{regexp} in #{data}"
  puts "---------"
  return false
rescue Timeout::Error
  puts "---------"
  puts "Read did timeout, current data is: #{data}"
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




