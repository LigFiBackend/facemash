# ---- Build Stage ----
FROM gradle:8.8-jdk21 AS build
WORKDIR /app

# Копируем только файлы для кэша зависимостей
COPY build.gradle settings.gradle ./
COPY gradle ./gradle

RUN gradle dependencies --no-daemon || true

# Копируем весь проект
COPY . .

# Собираем Spring Boot JAR
RUN gradle bootJar --no-daemon

# ---- Run Stage ----
FROM eclipse-temurin:21-jre
WORKDIR /app

COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
