require 'classy/utils'

module Classy
	class Converter
		def initialize
			$supported_formats = ["scss","less"]
			$conversion_map = {"scss" => method(:do_sass), "less" => method(:do_less)}
			$ext = ""
			$good_pack = []
			$bad_pack = []
		end

		def convert(src)
			@src = Classy::Utils::ClassyFile.resolve(src)

			if File.directory?(@src)
				$num_files = (Dir.entries(@src).size - 2)

				Dir.entries(@src).each do |file|
					next if file == '.' or file == '..'
					if File.directory?(file)
						Dir.entries(@src + '/' + file).each do |f|
							next if file == '.' or file == '..'
							start_conversion(f,true)
						end
					else
						start_conversion(@src + '/' + file,true)
					end
				end
			else
				$num_files = 1
				start_conversion(@src,false)
			end
		end

		def start_conversion(file,is_dir)
			$file_valid = Classy::Utils::ClassyFile.validate(file)
			if ($file_valid == true) and ($num_files > $bad_pack.size)
				prepare_conversion(file)
				$conversion_map[$ext.gsub(".","")].call()

				finish_conversion(is_dir)
			end
		end

		def do_sass
			#Convert mixins
			@txt.gsub!(/@mixin /,'.')
			# Convert includes
			@txt.gsub!(/@include /, '.')
			# Convert vars
			@txt.gsub!(/\$(\w+)/, '@\1')
			# Convert extends
			@txt.gsub!(/@extend ([\w\-\.]+);/, '&:extend( \1 );')
			@txt.gsub!(/ !default/, '')
			#@txt.gsub(/#{([\^}]+)}/, '~\"\1\"')
			@txt.gsub!(/~\"@(\w+)\"/, '@{\1}')
			@txt.gsub!(/adjust-hue\(/, 'spin(')
			@txt.gsub!(/(.*)[scss]/,'.less')
		end

		def do_less
			# TODO: currently LESS: .sample; is being interpreted as a mixin call when it's a class inheritance! FIX THIS

			#Convert vars
			@txt.gsub!(/@((?!media|include|charset|document|font-face|import|keyframes|page|supports)[a-zA-Z_]+)/, '$\1' )
			@txt.gsub!(/(@include\W+)[.#]([^(;]*\()/, '\1\2')
			# Convert to Mixin
			@txt.gsub!(/\.([\w\-]*)\s*\((.*)\)\s*\{/, '@mixin \\1(\\2){' )
			# Convert calls to mixin includes
			@txt.gsub!(/\.([\w\-]*\(.*\)\s*;)/, '@include \1')
			# Convert
			@txt.gsub!(/~"(.*)"/, '#{"\1"}')
			@txt.gsub!(/[\.]([\D][-\w]+)\;/, '@include \1();')
			@txt.gsub!('.less','.scss')
		end

		def get_new_ext
			if $ext == ".scss"
				return ".less"
			else $ext == ".less" 
				return ".scss"
			end
		end

		def prepare_conversion(file)
			$baseName = Classy::Utils::ClassyFile.name(file)
			$baseDir = Classy::Utils::ClassyFile.path(file)
			$new_ext = get_new_ext()
			@newFile = $baseDir + "/" + $baseName + $new_ext
			@txt = `cat #{file}`
		end

		def finish_conversion(is_dir)
			begin
				File.write(@newFile, @txt)

				if ($good_pack.size + $bad_pack.size) == $num_files
					Classy::Utils::PonyExpress.throw_message("Converted #{$good_pack.size} #{$good_pack.size == 1 ? 'file' : 'files'} and saved #{$good_pack.size == 1 ? 'it' : 'them'} to #{$baseDir}:")
					Classy::Utils::PonyExpress.throw_set($good_pack)

					if ($bad_pack.size > 0)
						Classy::Utils::PonyExpress.throw_message("Couldn't convert #{$bad_pack.size} unsupported #{$bad_pack.size == 1 ? 'file' : 'files'}:")
						Classy::Utils::PonyExpress.throw_set($bad_pack)
					end
				end
			rescue
				$user = `echo $USER`
				Classy::Utils::PonyExpress.throw_exception($user.strip+" was not able to write files. Please check permissions and try again")
			end
		end
	end
end