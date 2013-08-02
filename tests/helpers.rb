require 'open3'
require 'timeout'
require 'fileutils'

AUTHY_SCRIPT = File.expand_path("../authy-ssh-test", __FILE__)
AUTHY_COMMAND = "bash #{AUTHY_SCRIPT}"

ENV["DEBUG_AUTHY"] = "1"
SSH_KEY = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGRJbWu+WLVXYVADY3iQPE1kA7CIOSqHmskPM8qIAzKzq+1eRdmPwDZNmAvIQnN/0N7317Rt1bmTRLBwhl6vfSgL6677vUwsevPo27tIxdja67ELTh55xVLcJ3O8x2qkZsySgkLP/n+w3MUwLe1ht31AZOAsV7J7imhWipDijiysNgvHyeSWsHqExaL1blPOYJVHcqPbKY4SxFRq/MWeyPf/Sm24MFSKEaY6u0kNx8MLJ1X9X/YxmY9rdvzsZdQ7Z/PYhYt2Ja/0mzfYx2leeP2JQBsVfZZzAoFEPpw6mSP9kJREGe2tXvS9cRenhz/+V0+mvSJKG0f0Zzh428pTzN"

def read_until(pipe, regexp)
  data = ""
  Timeout.timeout(10) do
    4096.times do
      read_data = pipe.read(1)
      break if read_data.nil? || read_data.empty?

      data << read_data
      if data =~ regexp
        return true
      end
    end
  end

  red "\n---------"
  red "  Failed to match #{regexp} in #{data}"
  red "---------"
  return false
rescue Timeout::Error
  red "\n---------"
  red "  Read did timeout, current data is: #{data}"
  red "---------"
  return false
end

def authy_ssh(subcommnand, env = {}, root = false, &block)
  Open3.popen2e(env, "#{root ? 'sudo' : ''} #{AUTHY_COMMAND} #{subcommnand}") do |stdin, stdout, wait|
    block.call(stdin, stdout)
  end
end

module Kernel
  def colorize(text, color_code)
    "#{color_code}#{text}\e[0m"
  end

  def red(text)
    puts colorize(text, "\e[31m")
  end

  def green(text)
    puts colorize(text, "\e[32m")
  end

  def yellow(text)
    puts colorize(text, "\e[33m")
  end
end

