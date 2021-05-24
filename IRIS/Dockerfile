# 2021.1 preview (As of May 2021)
ARG IMAGE=containers.intersystems.com/intersystems/iris-community:2021.1.0.205.0
FROM $IMAGE

USER root

WORKDIR /opt/app
COPY web/graph.html .
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/app \
    && cp graph.html ${ISC_PACKAGE_INSTALLDIR}/csp/user/graph.html
   
USER ${ISC_PACKAGE_MGRUSER}

COPY src src
COPY iris.script /tmp/iris.script

# run iris and initial 
RUN iris start IRIS \
    && iris session IRIS < /tmp/iris.script \
    && iris stop IRIS quietly