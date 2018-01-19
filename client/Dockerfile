FROM drmurx/sensu

COPY install-deps.sh /usr/local/bin
COPY deadman-check.sh /usr/local/bin

RUN /usr/local/bin/install-deps.sh

CMD ["client"]
