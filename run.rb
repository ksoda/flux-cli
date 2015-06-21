#!/usr/bin/env ruby
require_relative 'flux/geocoder'

Flux::Geocoder.update_location!
res = Flux::Location.from_yaml
`./xflux -l #{res.latitude} -g #{res.longitude} &`
