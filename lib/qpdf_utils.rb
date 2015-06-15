require "qpdf_utils/version"

module QPDFUtils
  class Error < StandardError; end
  class BadFileType < Error; end
  class CommandFailed < Error; end
  class ProcessingError < Error; end
  class OutOfBounds < Error; end
  class InvalidPassword < Error; end

  class << self
    attr_writer :qpdf_binary
    def qpdf_binary
      @qpdf_binary ||= "qpdf"
    end

    def is_pdf?(file)
      IO.binread(file, 4) == "%PDF"
    end

    def configure
      yield self
    end
  end

  autoload :ShellRunner, 'qpdf_utils/shell_runner'
  autoload :PdfFile,     'qpdf_utils/pdf_file'
end
