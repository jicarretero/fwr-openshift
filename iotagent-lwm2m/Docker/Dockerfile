FROM telefonicaiot/lightweightm2m-iotagent:latest

WORKDIR /opt/iota-lwm2m

COPY config-blank.js /opt/iota-lwm2m

EXPOSE 4041 5684

ENTRYPOINT bin/lwm2mAgent.js config-blank.js
