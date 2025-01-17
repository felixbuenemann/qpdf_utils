# encoding: utf-8

module QPDFUtils
  class PdfFile
    def initialize(pdf_file, options = {})
      validate pdf_file

      @temp_files = []
      @file = pdf_file
      @qpdf_runner  = options[:qpdf_runner]  || ShellRunner.new(QPDFUtils.qpdf_binary)
      @password = options[:password]
    end

    def file
      if is_encrypted?
        @decrypted_file ||= decrypt @file, @password
      else
        @file
      end
    end

    def is_encrypted?
      if @is_encrypted.nil?
        @is_encrypted = check_encryption @file
      else
        @is_encrypted
      end
    end

    def pages
      @pages ||= count_pages
    end

    def extract_page(page, targetfile)
      extract_page_range(page..page, targetfile)
    end

    def extract_page_range(page_range, targetfile)
      page_from = page_range.first
      page_to = page_range.last
      if page_from < 1 || page_from > page_to || page_to > pages
        raise OutOfBounds, "page range #{page_range} is out of bounds (1..#{pages})", caller
      end
      @qpdf_runner.run %W(--empty --pages #{file} #{page_from}-#{page_to} -- #{targetfile})
      if File.size(targetfile) == 0
        raise ProcessingError, "extracted page is 0 bytes", caller
      end
      targetfile
    end

    # targetfile_template = "test-%d.pdf"
    def extract_pages(targetfile_template)
      targetfiles = (1..pages).map do |page|
        targetfile = sprintf(targetfile_template, page)
        @qpdf_runner.run %W(--empty --pages #{file} #{page} -- #{targetfile})
        targetfile
      end
      targetfiles
    end

    def append_files(*pdf_files, targetfile)
      pdf_files.map! do |pdf_file, password|
        validate pdf_file
        if check_encryption pdf_file
          decrypt pdf_file, password
        else
          pdf_file
        end
      end
      @qpdf_runner.run %W(--empty --pages #{file}) + pdf_files + %W(-- #{targetfile})
      targetfile
    end

    def cleanup!
      @temp_files.each do |temp_file|
        next if temp_file.nil?
        temp_file.close!
      end
      @temp_files = []
      @decrypted_file = nil
    end

    private

    def check_encryption(pdf_file)
        head, foot = 0, [File.size(pdf_file) - 4096, 0].max
        check_for_encrypt(pdf_file, head, foot)
    end

    def check_for_encrypt(pdf_file, *offsets)
      offsets.each do |offset|
        return true if IO.binread(pdf_file, 4096, offset).index("/Encrypt") != nil
      end
      false
    end

    def validate(pdf_file)
      raise Errno::ENOENT unless File.exist? pdf_file
      unless QPDFUtils.is_pdf? pdf_file
        raise BadFileType, "#{pdf_file} does not appear to be a PDF", caller
      end
    end

    def decrypt(pdf_file, password = nil)
      temp_file = Tempfile.new ["qpdf_utils_decrypt", ".pdf"]
      temp_file.close
      @temp_files << temp_file
      begin
        @qpdf_runner.run %W(--decrypt --password=#{password} #{pdf_file} #{temp_file.path})
      rescue CommandFailed
        if $?.exitstatus == 2
          raise InvalidPassword, "failed to decrypt #{pdf_file}, invalid/missing password?", caller
        else
          raise
        end
      end
      temp_file.path
    end

    def count_pages
      output = @qpdf_runner.run_with_output %W(--show-npages #{file})
      num_pages = output.to_i
      if num_pages == 0
        raise ProcessingError, "could not determine number of pages", caller
      end
      num_pages
    end

  end
end
