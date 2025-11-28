# ---- Build Stage ----
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app

# Копируем файлы сборки
COPY build.gradle settings.gradle ./
COPY gradlew .
COPY gradle ./gradle

# Кэшируем зависимости
RUN chmod +x gradlew
RUN ./gradlew dependencies --no-daemon || true

# Копируем остальной проект (src)
COPY . .

# Ещё раз даём права, потому что gradlew перезаписался из COPY . .
RUN chmod +x gradlew

# Собираем приложение
RUN ./gradlew bootJar --no-daemon

# ---- Run Stage ----
FROM eclipse-temurin:17-jre
WORKDIR /app

COPY --from=build /app/build/libs/app.jar .

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
