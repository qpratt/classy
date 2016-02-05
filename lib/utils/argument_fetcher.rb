module Classy
	module Utils
		class ArgumentFetcher
			$args = ARGV.nil? ? ARGV : []

			class << self
				def has_args
					if $args.size > 0
						return true
					else
						return false
					end
				end

				def fetch_args
					$args = ARGV

					return $args
				end

				def num_args
					return $args.size
				end
			end
		end
	end
end