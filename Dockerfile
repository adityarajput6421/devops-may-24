# build frontend steg 1
FROM node:20-alpine as frontend-builder

WORKDIR /app/frontend

COPY frontend/package*.json ./

RUN npm install

COPY frontend/ ./
RUN npm run build

#build java backned with maven steg 2

FROM maven:3.9.4 eclipse-temurin:17-jdk-alpine as backend-builder

WORKDIR /app/backend

COPY backend/pom.xml ./
COPY backend/.mvn .mvn
COPY backend/mvnw ./
RUN mvn dependency:go-offline
COPY backend/ .
RUN .mvnw clean package -DskipTests

#build stage 3 --- Final Stage 

FROM eclipse-temurin:17-jdk-alpine as builder

WORKDIR /app


COPY --from=backend-builder /app/backend/target/*.jar app.jar

COPY --from=frontend-builder /app/frontend/build /app/public/

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]



