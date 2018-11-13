FROM orangeopensource/fiware-cepheus:1.0.0

copy ep.sh /

RUN chmod -R g+w /var/log && chmod -R g+w /opt && chmod -R g+rxw /etc/supervisor && chmod +x /ep.sh

EXPOSE 8080 8081

WORKDIR /opt/cepheus

ENTRYPOINT ["/ep.sh"]
