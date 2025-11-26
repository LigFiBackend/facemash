FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Копируем исходный код
COPY . .

# Даем права и собираем проект
RUN chmod +x gradlew && \
    ./gradlew clean bootJar --no-daemon

# Запускаем приложение
ENTRYPOINT ["java", "-jar", "build/libs/*.jar"]
