# Student Management – Docker Deployment

This project is a Spring Boot application for managing students, built with Maven.

## Architecture

The application is deployed with **two Docker containers**:

1. **App container (`student-app`)**
   - Built from the project source using a multi-stage `Dockerfile`
   - Runs the Spring Boot jar: `student-management-0.0.1-SNAPSHOT.jar`
   - Exposes port **8080**

2. **Database container (`student-db`)**
   - Based on the official **MySQL 8.0** image
   - Database name: `studentdb`
   - Credentials:
     - user: `root`
     - password: `root`
   - Exposes port **3306**

Both services are defined in [`docker-compose.yml`](./docker-compose.yml) and communicate over a private Docker network (`student-net`).  
The application connects to the database using the JDBC URL:

```properties
jdbc:mysql://db:3306/studentdb
```

where `db` is the Docker Compose service name of the MySQL container.

## Files

- [`Dockerfile`](./Dockerfile)  
  - Build stage: uses `maven:3.9.2-eclipse-temurin-17` to run `mvn clean package -DskipTests`  
  - Run stage: uses `eclipse-temurin:17-jdk` and copies  
    `target/student-management-0.0.1-SNAPSHOT.jar` -> `/app/app.jar`

- [`docker-compose.yml`](./docker-compose.yml)  
  - Defines two services: `app` (Spring Boot) and `db` (MySQL 8)
  - Maps ports:
    - `8080:8080` for the app
    - `3306:3306` for the database

- [`src/main/resources/application.properties`](./src/main/resources/application.properties)  
  - Configures Spring Boot to use the MySQL container:
    ```properties
    spring.datasource.url=jdbc:mysql://db:3306/studentdb?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
    spring.datasource.username=root
    spring.datasource.password=root
    spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
    spring.jpa.hibernate.ddl-auto=update
    spring.jpa.database-platform=org.hibernate.dialect.MySQLDialect
    ```

## How to build and run with Docker

From the project root:

1. **Build and start the containers**

   ```bash
   docker compose up --build
   # or: docker-compose up --build
   ```

2. **Access the application**

   - Application: [http://localhost:8080](http://localhost:8080)
   - Database (optional from host): `localhost:3306`  
     - DB: `studentdb`, user: `root`, password: `root`

3. **Stop the containers**

   ```bash
   docker compose down
   # or: docker-compose down
   ```

This setup demonstrates:
- A Docker image for the **Spring Boot project**
- A Docker image for the **SQL database (MySQL)**
- How both are orchestrated together with **Docker Compose**.
