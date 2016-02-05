# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'classy/version'

Gem::Specification.new do |spec|
  spec.name          = "classy"
  spec.version       = Classy::VERSION
  spec.date          = '2016-02-01'
  spec.authors       = ["Qiydaar Pratt"]
  spec.email         = ["q@qiydaarpratt.com"]
  spec.summary       = %q{Convert from Sass to Less, and vice versa.}
  spec.description   = %q{Classy is a tool to help teams to diversify themselves and support both of the major CSS pre-processors in one codebase without the need for knowledge of both.}
  spec.homepage      = "http://classy.qiydaarpratt.com/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($\)
  spec.require_paths = ["lib"]
end
