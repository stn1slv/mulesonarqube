# Build stage - download plugins
FROM alpine:latest as downloader

RUN apk add --no-cache curl

# Download Mule SonarQube plugin
RUN curl -L -f --retry 3 --retry-delay 5 \
    -o /tmp/mule-validation-sonarqube-plugin-mule.jar \
    https://github.com/stn1slv/mule-sonarqube-plugin/releases/download/1.1.3/mule-validation-sonarqube-plugin-1.1.3-mule.jar

#Dockerizing SonarQube
FROM    sonarqube:9.9-community

LABEL   version="SonarQube 9.9 with Mule Plugin"
LABEL   description="SonarQube 9.9 with Mule Plugin"

ENV     SONAR_HOME /opt/sonarqube

WORKDIR $SONAR_HOME
VOLUME  $SONAR_HOME/data
VOLUME  $SONAR_HOME/conf
VOLUME  $SONAR_HOME/extensions
VOLUME  $SONAR_HOME/logs

# Install Mule SonarQube plugin
# Copy downloaded plugin from build stage
COPY --from=downloader /tmp/mule-validation-sonarqube-plugin-mule.jar $SONAR_HOME/extensions/plugins/

RUN  ls -ltr $SONAR_HOME/extensions/plugins

# HTTP Service Port
WORKDIR ${SONAR_HOME}
EXPOSE 9000

USER sonarqube
STOPSIGNAL SIGINT

ENTRYPOINT ["/opt/sonarqube/docker/entrypoint.sh"]