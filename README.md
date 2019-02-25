# dnstwist-server

dnstwist-server accepts get requests to execute dnstwist scans of
a given domain's typosquatters.

## Run it

### With docker hub

```
$ docker run --restart=always -p 8080:8080 -d -it samnissen/dnstwist-server
```

### With docker

```
$ git clone git@github.com:samnissen/dnstwist-server.git
$ docker build . -t dnstwist-server
$ docker run --restart=always -p 8080:8080 -d -it dnstwist-server
```

### Or test it out locally

```
$ rackup -p 8080
```

## How it works

```
$ wget http://localhost:8080/maximumfun.org?callback=http%3A%2F%2Fyour.domain%2Fyour%2Fapi%2Fpath.json
```

This will eventually post the results of the dnstwist scan of maximumfun.org
typosquatters to http://your.domain/your/api/path.json
as the body of the request. Your API must be ready to accept this data,
which will be the JSON output of dnstwist.

### Options

Add any of these options, separated by a comma,
and the server will pass them as flags to dnstwist:
- registered
- ssdeep
- mxcheck
- geoip

So, adding `&opts=registered,geoip` to your get request is equivalent to

```
$ dnstwist.py --registered --geoip --format json some.domain
```
