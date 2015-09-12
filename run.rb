#!/usr/bin/env ruby
require_relative 'initialize'
require_relative 'flux/geocoder'

Flux::Geocoder.update_location!
res = Flux::Location.from_yaml
exec "#{Flux.root_join 'xflux'} -l #{res.latitude} -k 2000"
