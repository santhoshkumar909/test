FROM maven:3.5.2-jdk-8-alpine AS MAVEN_TOOL_CHAIN
COPY pom.xml /tmp/
COPY bynature-dashboard-application /tmp/bynature-dashboard-application/
COPY bynature-dashboard-controller /tmp/bynature-dashboard-controller/
COPY bynature-dashboard-model /tmp/bynature-dashboard-model/
COPY bynature-dashboard-repository /tmp/bynature-dashboard-repository/
COPY bynature-dashboard-service /tmp/bynature-dashboard-service
WORKDIR /tmp/
RUN mvn -Pdev clean install -Pdocker

FROM gcr.io/distroless/java:11
COPY --from=MAVEN_TOOL_CHAIN /tmp/bynature-dashboard-application/target/bynature-dashboard-application-0.0.1-SNAPSHOT.jar app.jar

ENV JAVA_OPTS="-Xmx512m -Xms256m -DprofileActive=dev"
CMD [ "app.jar" ]

# RUN sh -c 'touch /app.jar'
# ENV JAVA_OPTS="-Xmx512m -Xms256m"
# ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -DprofileActive=dev -jar app.jar"]
