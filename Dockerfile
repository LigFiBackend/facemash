FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

# Копируем Gradle/Maven файлы
COPY build.gradle settings.gradle gradlew ./
COPY gradle ./gradle

# Загружаем зависимости (кэш)
RUN ./gradlew dependencies || true

# Копируем проект
COPY . .

# Собираем JAR
RUN ./gradlew bootJar

# ─────────────────────────────────────────────

FROM eclipse-temurin:21-jre
WORKDIR /app

# Копируем JAR
COPY --from=build /app/build/libs/*.jar app.jar

# Порт приложения
EXPOSE 8080

ENV JAVA_OPTS="-Xms256m -Xmx512m"

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
