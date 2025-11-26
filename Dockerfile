FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Копируем исходный код
COPY . .

# Даем права на выполнение gradlew
RUN chmod +x ./gradlew

# Собираем jar
RUN ./gradlew clean bootJar --no-daemon

# Финальный образ — только JDK для запуска (JDK 17)
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Копируем собранный JAR из первого образа
COPY --from=0 /app/build/libs/*.jar app.jar

# Открываем порт
EXPOSE 8080

# Запускаем приложение
ENTRYPOINT ["java", "-jar", "app.jar"]
