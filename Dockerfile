FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app
COPY . .
RUN chmod +x ./gradlew && ./gradlew clean bootJar --no-daemon

EXPOSE 8080
CMD ["java", "-jar", "build/libs/*.jar"]
