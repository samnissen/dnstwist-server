require 'uri'
require 'net/http'
require 'cgi'

class DNSTwist
  SUPPORTED_PARAMETERS = [
    'registered', 'ssdeep', 'mxcheck', 'geoip'
  ]

  def lookup(domain, opts = '', callback)
    pid = fork do
      scan(domain, opts = '', callback)
    end

    Process.detach pid
  end

  private
    def scan(domain, opts = '', callback)
      # docker
      result = `/dnstwist/dnstwist.py#{opts_to_string(opts)} --format json #{URI.decode(domain)}`
      # macOS brew installed or unzipped version 1.02
      # result = `dnstwist#{opts_to_string(opts)} -j #{URI.decode(domain)}`

      post(result, callback)
    end

    def post(result, url)
      uri = URI.parse(CGI.unescape(url))
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'

      request = Net::HTTP::Post.new(uri.path)
      request.add_field('Content-Type', 'application/json')
      request.body = result
      response = http.request(request)
    end

    def opts_to_string(opts)
      return '' unless opts

      normalized_opts = opts.split(',').map { |o|
        o.gsub(/\s+/, '').downcase
      }.reject{ |o|
        !SUPPORTED_PARAMETERS.include?(o)
      }

      return '' unless normalized_opts&.any?

      ' --' + normalized_opts.join(" --")
    end
end
