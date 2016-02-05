#!/usr/bin/env ruby

require 'classy/utils'
require 'classy/converter'

module Classy
	def self.fetch_params
		if ARGV.length == 0 then
			throw_prompt()
		else
			#c = Classy::Converter.new
			#c.convert()
		end
	end

	def self.testy
		a = Classy::Converter.new
		a.convert('~/Downloads/wc')
		a.convert('~/Downloads/wc/app')
		a.convert('~/Downloads/wc/core')
	end

	#Classy.fetch_params()
	Classy.testy()
end