# encoding: utf-8
require 'open3'

module QPDFUtils
  class ShellRunner
    def initialize(binary)
      @binary = binary
    end

    def run(args)
      run_with_output(args)
      nil
    end

    def run_with_output(args)
      output, errors, status = Open3.capture3(@binary, *args)
      unless status.exitstatus == 0 || status.exitstatus == 3 # warning
        raise CommandFailed, "command #{cmd} failed with output: #{errors.inspect}", caller
      end
      output.chomp
    end
  end
end
