# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qpdf_utils/version'

Gem::Specification.new do |gem|
  gem.name          = "qpdf_utils"
  gem.version       = QPDFUtils::VERSION
  gem.authors       = ["Felix Buenemann"]
  gem.email         = ["buenemann@louis.info"]
  gem.description   = %q{The qpdf_utils gem is a port of gs_pdf_utils to qpdf and provides simple pdf processing.}
  gem.summary       = %q{QPDF Utilities}
  gem.homepage      = "http://github.com/fbuenemann/qpdf_utils"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
