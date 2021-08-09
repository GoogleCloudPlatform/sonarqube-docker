FROM marketplace.gcr.io/google/debian10 as downloader

ARG SONAR_GPG=679F1EE92B19609DE816FDE81DB198F93525EC1A
ARG SONAR_VERSION=9.0.1.46107
ARG GOSU_VERSION=1.11
ARG GOSU_GPG=B42F6819007F00F88E364FD4036A9C25BF357DD4

RUN set -x \
 && apt-get update && apt-get install -y --no-install-recommends gnupg dirmngr ca-certificates wget apache2-utils git unzip \
 && wget -q -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
 && wget -q -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
 && wget -q -O /usr/local/src/gosu.tar.gz "https://github.com/tianon/gosu/archive/$GOSU_VERSION.tar.gz" \
 && export GNUPGHOME="$(mktemp -d)" \
 && gpg --no-tty --keyserver keys.openpgp.org --recv-keys $GOSU_GPG \
 && gpg --no-tty --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
 && gpg --no-tty --keyserver keys.openpgp.org --recv-keys $GOSU_GPG \
 && wget -q -O /opt/sonarqube.zip https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
 && wget -q -O /opt/sonarqube.zip.asc https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
 && gpg --no-tty --batch --verify /opt/sonarqube.zip.asc /opt/sonarqube.zip \
 && unzip /opt/sonarqube.zip -d /opt/ \
 && mv /opt/sonarqube-$SONAR_VERSION /opt/sonarqube \
 && cd /usr/local/src \
 && git clone --depth=1 https://github.com/SonarSource/sonarqube.git \
 && rm -rf /opt/sonarqube/bin/*

COPY license-checksum /

RUN  set -x \
   && mkdir /opt/tmp \
   && wget -q -O /opt/tmp/LICENSE "https://raw.githubusercontent.com/dmeiners88/sonarqube-prometheus-exporter/develop/LICENSE" \
   && wget -q -O /opt/tmp/prometheus-exporter-1.0.0.jar "https://github.com/dmeiners88/sonarqube-prometheus-exporter/releases/download/v1.0.0-SNAPSHOT-2018-07-04/sonar-prometheus-exporter-1.0.0-SNAPSHOT.jar" \
   && cd /opt/tmp \
   && sha256sum -c /license-checksum \
   && if [ $? -ne 0 ] ; then \
         exit 2; \
      fi \
   && mv /opt/tmp/prometheus-exporter-1.0.0.jar /opt/sonarqube/extensions/plugins/ \
   && mv /opt/tmp/LICENSE /usr/share/LICENSE-prometheus-exporter \
   && rm -rf /opt/tmp

FROM marketplace.gcr.io/google/debian10

# Add debian backport source repository
RUN set -x \
    && apt update \
    && apt install -y \
    openjdk-11-jdk \
    wget \
    && rm -rf /var/lib/apt/lists/*

ENV SONARQUBE_HOME=/opt/sonarqube \
  SONAR_VERSION=9.0.1.46107 \
  # Database configuration
  # Defaults to using H2
  SONARQUBE_JDBC_USERNAME=sonar \
  SONARQUBE_JDBC_PASSWORD=sonar \
  SONARQUBE_JDBC_URL=

ENV C2D_RELEASE 9.0.1

# Http port
EXPOSE 9000
COPY --from=downloader /usr/local/bin/gosu /usr/local/bin/gosu
COPY --from=downloader /usr/local/src/gosu.tar.gz /usr/local/src/gosu.tar.gz
COPY --from=downloader /usr/local/src/sonarqube /usr/local/src/sonarqube
COPY --from=downloader /opt/sonarqube /opt/sonarqube

COPY --from=downloader /usr/share/LICENSE-prometheus-exporter /usr/share/LICENSE-prometheus-exporter

RUN set -x \
  && groupadd -r sonarqube && useradd -r -g sonarqube sonarqube \
  && chmod +x /usr/local/bin/gosu \
  && chown -R sonarqube:sonarqube /opt/sonarqube \
  && gosu nobody true

VOLUME "$SONARQUBE_HOME/extensions"

WORKDIR $SONARQUBE_HOME
COPY run.sh $SONARQUBE_HOME/bin/

ENTRYPOINT ["./bin/run.sh"]
