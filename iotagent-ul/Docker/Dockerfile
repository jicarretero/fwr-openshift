FROM fiware/iotagent-ul:1.5.0

WORKDIR /opt/iotaul

COPY config-blank.js /opt/iotaul

RUN cd /opt/iotaul && \
    yum install -y gcc-c++ make yum-utils git krb5-devel zeromq-dev && \
    cd /opt/iotaul && npm install mosca --production && \
    chmod -R g+w /opt/iotaul && \
    yum erase -y gcc-c++ gcc ppl cpp glibc-devel glibc-headers kernel-headers libgomp libstdc++-devel mpfr libss yum-utils libxml2-python git

EXPOSE 4041 7896

ENTRYPOINT bin/iotagent-ul config-blank.js
