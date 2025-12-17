# ---------- Build stage ----------
FROM maven:3.9.2-eclipse-temurin-17 AS build
WORKDIR /app

# Copy Maven project
COPY pom.xml .
COPY src ./src

# Debug: List files to verify RootController is present
RUN find src -name "RootController.java" && ls -la src/main/java/tn/esprit/studentmanagement/controllers/ || echo "Controllers not found"

# Build the project (skip tests for image build; CI will run tests)
RUN mvn -B clean package -DskipTests

# ---------- Run stage ----------
FROM eclipse-temurin:17-jdk
WORKDIR /app

# Copy the built jar from previous stage (exact name from pom.xml)
COPY --from=build /app/target/student-management-0.0.1-SNAPSHOT.jar app.jar

# Expose application port
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java","-jar","/app/app.jar"]