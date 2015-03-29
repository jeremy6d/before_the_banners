FROM phusion/passenger-ruby22
MAINTAINER Jeremy Weiland (jeremy@jeremyweiland.com)

ENV RAILS_ENV production
ENV DATABASE_URL mongodb://db:27017/beforethebanners

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y -q imagemagick
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
ADD ./ext/nginx/main.d /etc/nginx/main.d/
ADD ./ext/nginx/beforethebanners.com.conf /etc/nginx/sites-enabled/beforethebanners.com.conf
RUN rm /etc/nginx/sites-enabled/default
RUN rm -f /etc/service/nginx/down

RUN mkdir -p /etc/my_init.d
ADD ./ext/precompile_assets.sh /etc/my_init.d/precompile_assets.sh
RUN chmod +x /etc/my_init.d/precompile_assets.sh

CMD ["/sbin/my_init"]

# RUN mkdir /home/app/tmp
# WORKDIR /home/app/tmp 
# ADD ./Gemfile Gemfile
# ADD ./Gemfile.lock Gemfile.lock
# RUN "bundle install --without development test"
# RUN chown -R app .
RUN mkdir /home/app/beforethebanners
ADD ./app /home/app/beforethebanners.com/app
ADD ./bin /home/app/beforethebanners.com/bin
ADD ./config /home/app/beforethebanners.com/config
ADD ./db /home/beforethebanners.com/db
ADD ./lib /home/beforethebanners.com/lib
RUN mkdir /home/beforethebanners.com/log
RUN touch /home/beforethebanners.com/log/production.log
ADD ./public /home/beforethebanners.com/public
RUN mkdir /home/beforethebanners.com/tmp
ADD ./vendor /home/beforethebanners.com/vendor

WORKDIR /home/app/beforethebanners.com
RUN bundle install --without development test
RUN chown -R app:app /home/app
EXPOSE 80