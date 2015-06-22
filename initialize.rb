module Flux
  ROOT = File.dirname(__FILE__)
	def self.root_join(path)
		File.join(ROOT, path)
	end
end

xflux_url = 'https://justgetflux.com/linux/xflux64.tgz'
`curl #{xflux_url} | tar -xz` unless File.exist? Flux.root_join 'xflux'
