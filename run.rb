#!/usr/bin/env ruby
require 'open-uri'
require 'geocoder'

TOKYO = [36, 138]
Geocoder.configure(timeout: 15)
res = Geocoder.search(open('http://whatismyip.akamai.com').read).first ||
	Struct.new(:latitude, :longitude).new(TOKYO[0], TOKYO[1])
`./xflux -l #{res.latitude} -g #{res.longitude} &`

