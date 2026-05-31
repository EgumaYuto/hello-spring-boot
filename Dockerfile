FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

COPY build/libs/hello-spring-boot-1.0-SNAPSHOT.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
