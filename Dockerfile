# Build the Java 17 server
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /src
COPY pom.xml .
COPY src ./src
RUN mvn -B -DskipTests package

# Small Java 17 runtime image
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /src/target/PvZ-TV-server.jar /app/PvZ-TV-server.jar
RUN mkdir -p /app/data
EXPOSE 26667/tcp 27667/tcp 27671/tcp 29667/tcp
CMD ["java", "-Xms64m", "-Xmx384m", "-jar", "/app/PvZ-TV-server.jar", "--base=26667", "--shards=1", "--dashboard=false"]
