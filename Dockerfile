ARG FRM='testdasi/debian-buster-slim-base'
ARG TAG='latest'

FROM ${FRM}:${TAG}
ARG FRM
ARG TAG

# Each brick in a volume needs a port in range 49152 - 49155. Here we default to 10 ports
ENV BRICK_PORT_RANGE 49152-49162
ENV MOUNT_PATH
ENV GLUSTER_VOL

EXPOSE 24007/tcp \
    24008/tcp \
    38465/tcp \
    38466/tcp \
    38467/tcp \
    38469/tcp \
    2049/tcp \
    111/tcp \
    111/udp \
    ${BRICK_PORT_RANGE}/tcp

ADD scripts /

RUN /bin/bash /install.sh \
    && rm -f /install.sh

#metadata
VOLUME ["/var/lib/glusterd"]
#log
VOLUME ["/var/log/glusterfs"]
#config
VOLUME ["/etc/glusterfs"]

ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
#CMD ["/usr/sbin/glusterd","-N"]

HEALTHCHECK CMD /healthcheck.sh

RUN echo "$(date "+%d.%m.%Y %T") Built from ${FRM} with tag ${TAG}" >> /build_date.info
