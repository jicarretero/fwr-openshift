# Cygnus
Cygnus was hard to crack, but I finally got it working. The main problem is that there is no version of Cygnus labeled as 1.8.0 which is the one they wanted to test. So, I managed to get a copy of a cygnus I had running somewhere and I uploaded it to my own github: jicarretero/cygnus-ngsi:1.8.0

But this version doesn't work with Openshift due to permissions issues, so I had to create an image from that one using the Dockerfile (Docker/Dockerfile).

Once I created the image, I uploaded it to Dockerhub as jicarretero/cygnus-ngsi-ff-jicg:1.8.0

There was
    # CONFIGMAP para MySQL
    oc create configmap cygnus-agent-config-mysql --from-file=conf.mysql/
    
    # CONFIGMAP para MongoDB
    oc create configmap cygnus-agent-config --from-file=conf/

So, we can create apps according to Openshift/cygnus-mongo.yaml or Openshift/cygnus-mysql.yaml


