# -------- Stage 1: Build with Maven --------
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /app

# Clone your repo (avoid this in production builds—better to COPY local code)
RUN apt-get update && apt-get install -y git \
    && git clone https://github.com/trainingcollection/maven-web-app-project-kk-funda.git .

# Resolve dependencies and build
RUN mvn clean package -DskipTests

# -------- Stage 2: Deploy to Tomcat --------
FROM tomcat:10.1-jdk17-temurin

# Clean out default webapps (optional for production)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR from build stage
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/app.war

# Expose port
EXPOSE 8085

# Start Tomcat (default CMD works fine)

