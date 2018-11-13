FROM node:8.9.4-slim
RUN apt-get update && \
    apt-get install -y git bzip2 && \
    npm install -g grunt-cli && \
    git clone https://github.com/telefonicaid/iotagent-json /opt/iotagent-json && \
    chmod +x /opt/iotagent-json/bin/iotagent-json && \
    cd /opt/iotagent-json && \
    npm install && \
    chmod -R g+w /opt/iotagent-json

COPY config.js /opt/iotagent-json/config.js

WORKDIR /opt/iotagent-json

ENV NODE_ENV=production
EXPOSE 4041 1884

ENTRYPOINT bin/iotagent-json config.js

