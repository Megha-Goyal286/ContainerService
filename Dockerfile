# Build Docker
ARG F_REGISTRY

FROM ${F_REGISTRY}fxtrt-base-openjdk14 AS build
ARG F_GITHUB_ACTOR=""
ARG F_GITHUB_TOKEN=""

COPY . /app
RUN cd /app; ./gradlew container-service:bootJar

# Final binary Docker
FROM ${F_REGISTRY}fxtrt-base-openjdk14
ARG app_version
ENV JAVA_OPTS=""
RUN mkdir /app
COPY --from=build /app/container-service/build/libs/container-service-${app_version}.jar /app/app.jar
ENTRYPOINT java $JAVA_OPTS -javaagent:/opt/newrelic/newrelic.jar -jar -Djavax.net.ssl.trustStore=/app/container-service/src/main/resources/cassandra_truststore.jks -Djavax.net.ssl.trustStorePassword=$F_TRUSTSTORE_PASSWORD /app/app.jar
