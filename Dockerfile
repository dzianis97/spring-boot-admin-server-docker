# build
FROM maven:3.6.3-jdk-11 AS build-stage
LABEL maintainer="gridiushkodenis@gmail.com"

COPY pom.xml /build/
COPY src /build/src/
WORKDIR /build/
RUN mvn clean install

# run
FROM java:11-jre-alpine
LABEL maintainer="gridiushkodenis@gmail.com"

ARG BUILD_DATE
ARG BUILD_NAME
ARG BUILD_VERSION
ARG VCS_REF

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name=$BUILD_NAME
LABEL org.label-schema.description="Spring Boot Admin Server Docker"
LABEL org.label-schema.url="https://github.com/dzianis97/spring-boot-admin-server-docker"
LABEL org.label-schema.vcs-url="https://github.com/dzianis97/spring-boot-admin-server-docker"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.vendor="Denis Gridiushko"
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.docker.cmd="docker run -d -p 8080:8080 --name spring-boot-admin-server denis97/spring-boot-admin-server"

RUN apk add --no-cache curl
COPY --from=build-stage /build/target/*.jar /opt/spring-boot-admin-server.jar
WORKDIR /opt
EXPOSE 8080

ENTRYPOINT ["java","-jar","spring-boot-admin-server.jar"]