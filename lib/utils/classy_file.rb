module Classy
	module Utils
		class ClassyFile
			class << self
				def name(f)
					return File.basename(f).split('.')[0...-1].join('.')
				end

				def extension(f)
					return File.extname(f)
				end

				def path(f)
					return File.dirname(f)
				end

				def resolve(f)
					return `readlink -f #{f}`.strip
				end

				def validate(f)
					$ext = Classy::Utils::ClassyFile.extension(f.strip).strip

					if $supported_formats.include? $ext.gsub('.','')
						$good_pack << f
						return true
					else
						$bad_pack << f
						return false
						#Classy::Utils::PonyExpress.throw_exception('File: #{f} is not a supported file.')
					end
				end
			end
		end
	end
end