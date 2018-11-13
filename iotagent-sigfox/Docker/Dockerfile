FROM fiware/sigfox-iotagent:1.0.0

WORKDIR /opt/iotasigfox

RUN chmod -R g+w /opt/iotasigfox

COPY config.js /opt/iotasigfox

EXPOSE 4041 17428

ENTRYPOINT bin/iotagent-sigfox config.js
