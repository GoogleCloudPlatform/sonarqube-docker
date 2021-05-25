sonarqube-docker
============

Dockerfile source for SonarQube [docker](https://docker.io) image.

# Upstream
This source repo was originally copied from:
https://github.com/SonarSource/docker-sonarqube

# Disclaimer
This is not an official Google product.

## About

This image contains an installation Redis. 

For more information, see the [Official Image Marketplace Page](https://console.cloud.google.com/marketplace/details/google/sonarqube8).

### Prerequisites

Configure [gcloud](https://cloud.google.com/sdk/gcloud/) as a Docker credential helper:

```shell
gcloud auth configure-docker
```
### Pull command

```shell
gcloud docker -- pull marketplace.gcr.io/google/sonarqube8
```

# <a name="table-of-contents"></a>Table of Contents

* [Using Docker](#using-docker)
  * [Running Sonarqube](#running-sonarqube-docker)
    * [Starting a Sonarqube instance](#starting-a-sonarqube-instance-docker)
    * [Adding persistence](#adding-persistence-docker)
  * [Configurations](#configurations-docker)
    * [Using configuration volume](#using-configuration-volume-docker)
* [References](#references)
  * [Ports](#references-ports)
  * [Volumes](#references-volumes)
  * 
# <a name="using-docker"></a>Using Docker

## <a name="running-sonarqube-docker"></a>Running Sonarqube

### <a name="starting-a-sonarqube-instance-docker"></a>Starting a Sonarqube instance

Use the following content for the `docker-compose.yml` file, then run `docker-compose up`.

```yaml
version: "2"
services:
  sonarqube:
    container_name: some-sonaqube
    image: marketplace.gcr.io/google/sonarqube8
    expose:
      - 9000
    ports:
      - 127.0.0.1:9000:9000
    networks:
      - sonarnet
    environment:
      - SONARQUBE_JDBC_USERNAME=sonar
      - SONARQUBE_JDBC_PASSWORD=sonar 
      - SONARQUBE_JDBC_URL=
```
Or you can use docker run directly:

```shell
docker run -it --rm\
  --name some-sonaqube \
  -p 127.0.0.1:9000:9000 \
  --expose 9000 \
  -d \
  marketplace.gcr.io/google/sonarqube8
```
### <a name="adding-persistence-docker"></a>Adding persistence

Use the following content for the `docker-compose.yml` file, then run `docker-compose up`.

```yaml
version: "2"
services:
  sonarqube:
    container_name: some-sonaqube
    image: marketplace.gcr.io/google/sonarqube8
    expose:
      - 9000
    ports:
      - 127.0.0.1:9000:9000
    networks:
      - sonarnet
    environment:
      - SONARQUBE_JDBC_USERNAME=sonar
      - SONARQUBE_JDBC_PASSWORD=sonar 
      - SONARQUBE_JDBC_URL=
    volumes:
      - sonarqube_conf:/opt/sonarqube/conf
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_extensions:/opt/sonarqube/extensions
      - sonarqube_bundled-plugins:/opt/sonarqube/lib/bundled-plugins
```
Or you can use `docker run` directly:

```shell
docker run -it --rm\
  --name some-sonaqube \
  -p 127.0.0.1:9000:9000 \
  --expose 9000 \
  -d \
  -v sonarqube_conf:/opt/sonarqube/conf \
  -v sonarqube_data:/opt/sonarqube/data \
  -v sonarqube_extensions:/opt/sonarqube/extensions \
  -v sonarqube_bundled-plugins:/opt/sonarqube/lib/bundled-plugins \
  marketplace.gcr.io/google/sonarqube8
```

## <a name="configurations-docker"></a>Configurations

See [Volume reference](#references-volumes) for more details.

# <a name="references"></a>References

## <a name="references-ports"></a>Ports

