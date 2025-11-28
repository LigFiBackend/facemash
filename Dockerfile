# ---- Build Stage ----
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app

# Копируем файлы сборки
COPY gradlew .
COPY build.gradle settings.gradle ./
COPY gradle ./gradle

# Делаем gradlew исполняемым
RUN chmod +x gradlew

# Кэшируем зависимости
RUN ./gradlew dependencies --no-daemon || true

# Копируем остальной проект
COPY . .

# Собираем приложение
RUN ./gradlew bootJar --no-daemon

# ---- Run Stage ----
FROM eclipse-temurin:17-jre
WORKDIR /app

COPY --from=build /app/build/libs/app.jar .

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
