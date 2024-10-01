# Используем базовый образ с Java
FROM openjdk:17-jdk-slim AS build

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы Gradle
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle.kts .

# Копируем исходный код
COPY src src

# Сборка проекта
RUN ./gradlew build --no-daemon

# Создаем финальный образ
FROM openjdk:17-jdk-slim

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем JAR файл из этапа сборки
COPY --from=build /app/build/libs/*.jar app.jar

# Запускаем приложение
ENTRYPOINT ["java", "-jar", "app.jar"]