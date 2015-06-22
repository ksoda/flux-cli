#!/usr/bin/env ruby
require_relative 'initialize'
require_relative 'flux/geocoder'

Flux::Geocoder.update_location!
res = Flux::Location.from_yaml
fork do
	`#{Flux.root_join 'xflux'} -l #{res.latitude} -g #{res.longitude} -k1000 -nofork`
end
