FROM nginx:stable

MAINTAINER John Koelndorfer "jkoelndorfer@gmail.com"

# supervisor, simp_le, cron installation
RUN apt-get -y update && \
    apt-get -y --no-install-recommends --no-install-suggests install cron git python-yaml supervisor vim && \
    rm -rf /etc/cron{tab,.{d,daily,hourly,weekly,monthly}} && \
    mkdir -p /var/www && \
    git clone https://github.com/kuba/simp_le.git /opt/simp_le && \
    cd /opt/simp_le && \
    git reset --hard "3a103b76f933f9aef782a47401dd2eff5057a6f7" && \
    rm -rf .git && \
    ./bootstrap.sh && \
    ./venv.sh

RUN rm -rf /var/lib/apt/lists/*

COPY app/cert_renew.py /app/cert_renew.py
COPY app/crontab /app/crontab
COPY app/default.conf.template /app/default.conf.template
COPY app/entrypoint.sh /entrypoint.sh
COPY app/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN crontab /app/crontab

EXPOSE 80 443

VOLUME ["/app/cert_renew.yml", "/certs"]

CMD ["/entrypoint.sh"]
