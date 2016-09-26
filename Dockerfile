FROM nginx:stable

MAINTAINER John Koelndorfer "jkoelndorfer@gmail.com"

# supervisor, simp_le, cron installation
RUN apt-get -y update && \
    apt-get -y --no-install-recommends --no-install-suggests install cron git supervisor && \
    rm -rf /etc/cron.{d,hourly,daily,weekly,monthly} && \
    mkdir /well-known && \
    git clone https://github.com/kuba/simp_le.git /opt/simp_le && \
    cd /opt/simp_le && \
    git reset --hard "3a103b76f933f9aef782a47401dd2eff5057a6f7" && \
    rm -rf .git && \
    ./bootstrap.sh

COPY default.conf.template /etc/nginx/default.conf.template
COPY entrypoint.sh /entrypoint.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80 443

CMD ["/entrypoint.sh"]
