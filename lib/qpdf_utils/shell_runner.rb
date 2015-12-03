# encoding: utf-8
begin
  require 'posix/spawn'
rescue LoadError
  require 'open3'
end

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
      cmd = [@binary, *args]
      output, errors, status = capture(cmd)
      unless status.exitstatus == 0 || status.exitstatus == 3 # warning
        raise CommandFailed, "command #{cmd} failed with output: #{errors.inspect}", caller
      end
      output.chomp
    end

    private

    if defined? ::POSIX::Spawn

      def capture(cmd)
        pid, input, output, errors = POSIX::Spawn.popen4(*cmd)
        input.close
        _, status = Process.waitpid2(pid)
        [output.read, errors.read, status]
      ensure
        [input, output, errors].each { |io| io.close unless io.closed? }
      end

    else

      def capture(cmd)
        Open3.capture3(*cmd)
      end

    end

  end
end
