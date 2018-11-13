.. _Top:

===========================================
FIWARE Componets: Installation in Openshift
===========================================

.. contents:: :local:

Introduction
============
There are a few FIWARE_ components which has been successfully installed under OpenShift.

* Orion
* IoT Agents
* Cygnus
* STH-Commet

Some aditional components are needed in order to make things work:

* MongoDB
* Mosquitto Server
* ...

Helper Container Installation
=============================
MongoDB
-------
It is easy to deploy a Mongo Database in order to work with it in the deployment

.. code:: bash

 oc new-app mongo:3.6 --name mongo

Mysql
-----
To deploy a MySQL databas we can proceed this way:

.. code:: bash
  
   oc new-app centos/mysql-57-centos7 --name mysql \
   -e MYSQL_ROOT_PASSWORD=root

MySQL is going to be used in Cygnus, so, just using the root password Cygnus will be able to create the database by itself.

Mosquitto
---------
We might need to install a MQTT server in order to be able to use it with iot-agent-json. The most common one is Mosquitto.

.. code:: bash
 
  oc new-app  jicarretero/alpine-mosquitto --name mosquitto -o yaml > mosquitto.yaml
  oc create -f mosquitto.yaml


If we need to expose the port (it is not an HTTP port) we migh need to do some port forwarding:

.. code:: bash
 
  oc port-forward -p <pod> 1883:1883

The image was built using this Dockerfile
 
.. code:: Dockerfile

 FROM alpine
 
 RUN apk update && apk upgrade && apk add mosquitto mosquitto-clients  && \
        sed -i 's/log_dest syslog/log_dest stdout/g' /etc/mosquitto/mosquitto.conf && \
        rm -f /var/cache/apk/* && \
        chmod -R g+w /etc/mosquitto

 EXPOSE 1883
 
 ENTRYPOINT /usr/sbin/mosquitto -c /etc/mosquitto/mosquitto.conf



Orion Context Broker
====================
.. code:: bash

 oc new-app  fiware/orion:1.7.0 --name orion -o yaml > orion.yaml

We should edit the orion.yaml file in order to add the parameter "-dbhost mongo" to the entrypoint as Orion_ starts, so Orion can connect to the database.

.. code:: yaml

 .....
   kind: DeploymentConfig
 .....
       containers:
        - image: fiware/orion:1.7.0
          name: orion
          args:
            - -dbhost
            - mongo
          ports:
          - containerPort: 1026
            protocol: TCP
          resources: {}
 .....

Once changed the file, we can deploy Orion_ Context Broker this way:

 .. code:: bash

  oc create -f orion.yaml

IoT-Agents
==========

There are several IoT Agents. The most important ones are iotagent-json and iotagent-ul

IoT-Agent JSON
--------------

This agent recives the information in JSON format. It can use several transport layers like HTTP, MQTT, AMQP, etc. As usual, we needed to create a Dockerfile and make a few changes in *config.js*. 

A way to deploy it has been:

.. code:: bash

  oc new-app -e MONGO_HOST=mongo \
  -e ORION_HOST=orion \
  -e MQTT_HOST=mosquitto \
  jicarretero/iotagent-json-no-mosca-ff-remake-jicg:1.8.0 --name iotagent-json -o yaml > iotagent-json.yaml
  
Once the yaml file has been generated, we can create the application under Openstack:

.. code:: bash

  oc create -f iotagent-json.yaml


IoT-Agent UL
--------------
This agent is installed in a quite similar way to the previous one. There are 2 possible tags for the docker image of the agent: 1.4.0 and 1.5.0.

.. code:: bash

  oc new-app -e MONGO_HOST=mongo \
  -e ORION_HOST=orion \
  -e MQTT_HOST=mosquitto \
  jicarretero/jicarretero/iotagent-ul-mosca-ff-jicg:1.5.0 --name iotagent-ul -o yaml > iotagent-ul.yaml 
  
Once the yaml file has been generated, we can create the application under Openshift:

.. code:: bash

  oc create -f iotagent-ul.yaml


Cygnus
======
The Cygnus_ image has been created using another image. The repository is **jicarretero/cygnus-ngsi-ff-jicg:1.8.0**

Cygnus-mysql
------------
In order to create that Cygnus_:

.. code:: bash

  oc new-app jicarretero/cygnus-ngsi-ff-jicg:1.8.0 --name cygnus-mysql \
  -e CYGNUS_MYSQL_HOST=mysql \
  -e CYGNUS_MYSQL_PORT=3306 \
  -e CYGNUS_MYSQL_USER=root \
  -e CYGNUS_MYSQL_PASS=root -o yaml > new_cygnus_mysql.yaml


We also need to create a config Map so the directory where the configuration data is stored can be upgraded. Before creating the configMag, we should edit the file **agent.conf** so we can set the properties of or MySQL database. In example, as created previously.

.. code:: bash

 oc create configmap cygnus-agent-config-mysql --from-file=conf.mysql/


Once the config map and the yaml is created, we edit the file in order to use the config map recently created

.. code:: yaml

   ....
   kind: DeploymentConfig
   ....
     spec
     ....
       template
         ....
         spec
           containers:
           - image: jicarretero/cygnus-ngsi-ff-jicg:1.8.0
             name: cygnus-mysql
             ports:
             - containerPort: 5050
               protocol: TCP
             - containerPort: 8081
               protocol: TCP
             resources: {}
             volumeMounts:
               - name: cygnus-agent-config-mysql
                 mountPath: /opt/apache-flume/conf
           volumes:
               - name: cygnus-agent-config-mysql
                 configMap:
                   name: cygnus-agent-config-mysql
     ......

Cygnus-mongo
------------
In order to create that Cygnus_:

.. code:: bash

  oc new-app jicarretero/cygnus-ngsi-ff-jicg:1.8.0 --name cygnus-mongo \
  -e CYGNUS_MONGO_HOSTS=mongo -e CYGNUS_MONGO_USER="" -e CYGNUS_MONGO_PASS="" -o yaml > new_cygnus_mongo.yaml

We also need to create a config Map so the directory where the configuration data is stored can be upgraded. Before creating the configMag, we should edit the file **agent.conf** so we can set the properties of or MySQL database. In example, as created previously.

.. code:: bash

 oc create configmap cygnus-agent-config-mongo --from-file=conf/


Once the config map and the yaml is created, we edit the file in order to use the config map recently created

.. code:: yaml

   ....
   kind: DeploymentConfig
   ....
     spec
     ....
       template
         ....
         spec
           containers:
           - image: jicarretero/cygnus-ngsi-ff-jicg:1.8.0
             name: cygnus-mysql
             ports:
             - containerPort: 5050
               protocol: TCP
             - containerPort: 8081
               protocol: TCP
             resources: {}
             volumeMounts:
               - name: cygnus-agent-config-mongo
                 mountPath: /opt/apache-flume/conf
           volumes:
               - name: cygnus-agent-config-mongo
                 configMap:
                   name: cygnus-agent-config-mongo
     ......

We must also be aware about the defined variable values: CYGNUS_MONGO_USER and CYGNUS_MONGO_PASS can have no value and this would make this cygnus not to work.

STH-Comet
=========
sth-comet_ is the Short historic document for FIWARE.

.. code:: yaml

  oc new-app -e MONGO_URI=mongo.fiware.svc jicarretero/sth-comet-ff-jicg:2.3.0 --name sth-comet -o yaml > new-sth-commet.yaml
  oc create -f new-sth-commet.yaml

We can expose the service if needed:
  oc expose service sth-comet --name=sth-comet --port=8666


Cepheus
=======
Cepheus consists of 2 processes: cepheus-broker and cepheus-cep. It is not a good Idea to run them using supervisord in the same container under Openshift. So, the way to make things run was a small rebuild of the Docker image using another entrypoint, one simple script named **ep.sh**.

.. code:: bash

 #!/bin/sh
 
 echo "Starting with KIND=${KIND}"
 
 if [ "x$KIND" = "xbroker" ]; then
     echo BROKER....
     java -jar cepheus-broker.jar -Dserver.port=8081
 elif [ "x$KIND" = "xcep" ]; then
     echo CEP....
     java -jar cepheus-cep.jar -Dserver.port=8080
 else
     echo "Try using KIND=cep|broker"
 fi
 
So, we need to run 2 instances of this docker, on with each possible kind of behaviour. This new docker image has been run to jicarretero/cepheus-ff-jicg:1.0.0
 
 .. code:: bash
 
  oc new-app jicarretero/cepheus-ff-jicg:1.0.0 -e KIND=cep --name cepheus-cep
  oc new-app jicarretero/cepheus-ff-jicg:1.0.0 -e KIND=broker --name cepheus-broker


.. _FIWARE: http://www.fiware.org/
.. _Orion: https://github.com/telefonicaid/fiware-orion
.. _Cygnus: https://github.com/telefonicaid/fiware-cygnus
.. _sth-coment: https://github.com/telefonicaid/fiware-sth-comet
