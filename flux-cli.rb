#!/usr/bin/env ruby
require_relative 'initialize'
require_relative 'flux/geocoder'

Flux::Geocoder.update_location!
res = Flux::Location.from_yaml

if pid = `pgrep  xflux`.to_i.nonzero?
	puts "already running in #{pid}"
	exit 0
end

exec "#{Flux.root_join 'xflux'} -l #{res.latitude} -k 2000"
