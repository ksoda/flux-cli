require 'open-uri'
require 'geocoder'
require 'yaml'

::Geocoder.configure timeout: 10
module Flux
	SETTING = 'setting.yml'
  # DEFAULT_LOC = [33, 130] # Fukuoka
	Location = Struct.new :latitude, :longitude do
		def self.from_yaml(file_name=SETTING)
			data = YAML.load File.read file_name
			new data['latitude'], data['longitude']
		end

		def self.build_hash
      Location.members.reduce({}) do |acc, k|
        acc.merge( k.to_s => yield(k) )
			end
		end

	end

	module Util
		def prompt(message)
			print "#{message}: "
			gets.chomp
		end
	end

	module Geocoder
		extend Util
    SERVICE_URL = 'http://whatismyip.akamai.com'
		def self.outdated?
			return true unless File.exist? SETTING
			week = 7 * 24 * 60**2
			(File.stat(SETTING).mtime - Time.now).to_i < -2 * week
		end

		def self.update_location!
			return true unless outdated?
			before_setting = if File.exist? SETTING
				YAML.load File.read SETTING
			else {}
			end
			File.write SETTING, (YAML.dump before_setting.merge fetch_location)
		end

    def self.fetch_location
      res = ::Geocoder.search(open(SERVICE_URL).read).first
			unless res
			  return Location.build_hash do |k|
	        prompt("Tell me your #{k}").to_f
				end
			end

			Location.build_hash { |k| res.send k }
    end

	end

end
