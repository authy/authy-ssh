require 'open3'
require 'timeout'

AUTHY_COMMAND = "bash #{File.expand_path("../authy-ssh-test", __FILE__)}"
ENV["DEBUG_AUTHY"] = "1"

def read_until(pipe, regexp)
  data = ""
  Timeout.timeout(10) do
    1024.times do
      read_data = pipe.read(1)
      break if read_data.nil? || read_data.empty? 

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

def authy_ssh(subcommnand, &block)
  Open3.popen2e("#{AUTHY_COMMAND} #{subcommnand}") do |stdin, stdout, wait|
    block.call(stdin, stdout)
  end
end

