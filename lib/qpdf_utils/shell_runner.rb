# encoding: utf-8
require 'shellwords'

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
      cmd = build_command(args)
      output = `#{cmd}`
      if $?.exitstatus > 0
        raise CommandFailed, "command #{cmd} failed with output: #{output}", caller
      end
      output
    end

    private

    def build_command(args)
      cmd = "#{@binary.shellescape} #{args.shelljoin} 2>&1"
    end
  end
end
