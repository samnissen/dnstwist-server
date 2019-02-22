FROM ruby:2.4

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV RACK_ENV=production

RUN apt-get update -qq
RUN apt-get install -fqq
RUN apt-get install -yqq build-essential net-tools apt-utils \
      libpq-dev ntp wget git unzip

RUN service ntp stop
RUN apt-get install -yqq fake-hwclock
RUN ntpd -gq &
RUN service ntp start

RUN apt-get install -yqq python-dev libfuzzy-dev python-dnspython \
      python-geoip python-whois python-requests python-ssdeep python-cffi

WORKDIR /
# Latest version -- searches far more domain possibilities
RUN git clone git://github.com/elceef/dnstwist.git

# Older, more terse version (faster)
# RUN wget https://github.com/elceef/dnstwist/archive/v1.02.zip
# RUN unzip v1.02.zip -d /
# RUN mv /dnstwist-1.02 /dnstwist

RUN mkdir -p /dnstwist-server
WORKDIR /dnstwist-server

RUN gem install sinatra rack

EXPOSE 8080

COPY ./server.rb /dnstwist-server/server.rb
COPY ./dns_twist.rb /dnstwist-server/dns_twist.rb

CMD ["ruby", "/dnstwist-server/server.rb", "-p", "8080"]
