require 'open-uri'
require 'geocoder'
require 'yaml'

::Geocoder.configure timeout: 15
module Flux
	SETTING = 'setting.yml'
  DEFAULT_LOC = [33, 130] # Fukuoka
	Location = Struct.new :latitude, :longitude do
		def self.from_yaml(file_name=SETTING)
			data = YAML.load File.read file_name
			new data['latitude'], data['longitude']
		end

	end

	module Geocoder
    SERVICE_URL = 'http://whatismyip.akamai.com'
		def self.outdated?
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
			default_location = Hash[ Location.members.map(&:to_s).zip(DEFAULT_LOC)]
      return default_location unless res
      Location.members.reduce({}) do |acc, m|
        acc.merge(m.to_s => res.send(m))
      end
    end

	end
end
