module Classy
	module Utils
		class PonyExpress
			class << self
				def throw_exception(error)
					puts "\n***** EXCEPTION *****"
					puts "\t"+error
					puts "\n"
					exit
				end

				def throw_message(message)
					puts "\n"
					puts "\t"+message
				end

				def throw_prompt
					# print "\nAre you sure you don't want to specify a file? (Enter path to file for 'YES' or simply press ENTER for 'NO': "
					puts "\n\tYou must specify a '.scss' or '.less' file!\n\n"
				end

				def throw_set(data_set)
					if data_set.is_a?(Object)
						data_set.each do |e|
							puts "\n\t\t#{e}"
						end
						puts "\n"
					end
				end
			end
		end
	end
end