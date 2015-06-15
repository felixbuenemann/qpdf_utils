# QPDFUtils

This gem provides some simple pdf utilities based on QPDF and was ported from [pdftk\_utils](https://github.com/felixbuenemann/pdftk_utils) which already used QPDF for decryption, but drops the dependency on PDFtk.

Currently it provides methods for detecting pdf files by magic, decrypting pdfs,
counting pdf pages and extracting a single, all or a range of pages from a pdf.

It is less resource hungry and faster than eg. ghostscript or imagemagick for the tasks provided.

It's still in alpha state and has no spec coverage, still it might suite your needs.

## System Requirements

This gem requires at least qpdf 4.2.0 to be installed.

## Installation

Add this line to your application's Gemfile:

    gem 'qpdf_utils', :git => "https://github.com/felixbuenemann/qpdf_utils"

And then execute:

    $ bundle

Due to it's early state, gem is not currently released on rubygems.

## Usage

```ruby
pdf = QPDFUtils::PdfFile.new "test.pdf"
# get page count
pdf.pages
# extract a page to page1.pdf
pdf.extract_page(1, "page1.pdf")
# extract all pages to separate pdfs (page-1.pdf, page-2.pdf, ...)
pdf.extract_pages("page-%d.pdf")
# extract pages 2 to 5
pdf.extract_page_range(2..5, "page2-5.pdf")
# append test2.pdf and test3.pdf to test.pdf and write to merged.pdf
pdf.append_files "test2.pdf", "test3.pdf", "merged.pdf"
# check if file is a pdf, by checking magic bytes
QPDFUtils.is_pdf? "test.pdf"
# open pdf protected with user password
pdf = QPDFUtils::PdfFile.new "test.pdf", password: "foobar"
# append (some) protected files
pdf.append_files "test2.pdf", ["test3.pdf", "test3pwd"], "merged.pdf"
```

## Configuration

If qpdf is not in your path, you can configure it:
```ruby
QPDFUtils.config do |c|
  c.qpdf_binary  = "/path/to/qpdf"
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
