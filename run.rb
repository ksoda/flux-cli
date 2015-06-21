#!/usr/bin/env ruby
require_relative 'flux/geocoder'

xflux_url = 'https://justgetflux.com/linux/xflux64.tgz'
`curl #{xflux_url} | tar -xz` unless File.exist? 'xflux'
Flux::Geocoder.update_location!
res = Flux::Location.from_yaml
fork do
	`./xflux -l #{res.latitude} -g #{res.longitude} -k1000 -nofork`
end
