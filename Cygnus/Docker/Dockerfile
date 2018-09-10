FROM jicarretero/cygnus-ngsi:1.8.0

# Environment variables
ENV CYGNUS_USER "cygnus"
ENV CYGNUS_HOME "/opt/fiware-cygnus"
ENV CYGNUS_VERSION "1.8.0_SNAPSHOT"
ENV CYGNUS_CONF_PATH "/opt/apache-flume/conf"
ENV CYGNUS_CONF_FILE "/opt/apache-flume/conf/agent.conf"
ENV CYGNUS_AGENT_NAME "cygnus-ngsi"
ENV CYGNUS_LOG_LEVEL "INFO"
ENV CYGNUS_LOG_APPENDER "console"
ENV CYGNUS_SERVICE_PORT "5050"
ENV CYGNUS_API_PORT "8081"
ENV CYGNUS_MYSQL_HOST "iot-mysql"
ENV CYGNUS_MYSQL_PORT "3306"
ENV CYGNUS_MYSQL_USER "mysql"
ENV CYGNUS_MYSQL_PASS "mysql"
ENV CYGNUS_MONGO_HOSTS "iot-mongo:27017"
ENV CYGNUS_MONGO_USER "mongo"
ENV CYGNUS_MONGO_PASS "mongo"
ENV CYGNUS_CKAN_HOST "iot-ckan"
ENV CYGNUS_CKAN_PORT "80"
ENV CYGNUS_CKAN_API_KEY ""
ENV CYGNUS_CKAN_SSL "false"
ENV CYGNUS_HDFS_HOST "iot-hdfs"
ENV CYGNUS_HDFS_PORT "50070"
ENV CYGNUS_HDFS_USER "hdfs"
ENV CYGNUS_HDFS_TOKEN ""
ENV CYGNUS_CARTO_USER "carto"
ENV CYGNUS_CARTO_KEY "carto"
ENV FLUME_HOME "/opt/apache-flume"

# Define the entry point
# ENTRYPOINT ["/cygnus-entrypoint.sh"]
ENTRYPOINT "/cygnus-entrypoint.sh"

# Ports used by cygnus-ngsi
EXPOSE ${CYGNUS_SERVICE_PORT} ${CYGNUS_API_PORT}

run chown -R root.root ${FLUME_HOME} && chmod -R g+w   ${FLUME_HOME} && \
    chown -R root.root ${CYGNUS_HOME} && chmod -R g+w ${CYGNUS_HOME} && \
    chown -R root.root /var/log/cygnus && chmod -R g+w /var/log/cygnus
