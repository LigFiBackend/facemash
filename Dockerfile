# ---- Build Stage ----
FROM gradle:8.8-jdk21 AS build
WORKDIR /app

COPY . .

# Делаем gradlew исполняемым
RUN chmod +x ./gradlew

# Собираем JAR
RUN ./gradlew bootJar --no-daemon

# ---- Run Stage ----
FROM eclipse-temurin:21-jre
WORKDIR /app

COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
