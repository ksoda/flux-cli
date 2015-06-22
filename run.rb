#!/usr/bin/env ruby
require_relative 'initialize'
require_relative 'flux/geocoder'

if pid = `ps -e |grep 'xflux$' |tr -s ' ' |cut -f1 -d' ' `.to_i.nonzero?
	puts "already running in #{pid}"
	exit 1
end

Flux::Geocoder.update_location!
res = Flux::Location.from_yaml
fork do
	`#{Flux.root_join 'xflux'} -l #{res.latitude} -g #{res.longitude} -k1000 -nofork`
end
