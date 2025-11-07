# 1. Use an official OpenJDK base image
FROM openjdk:17-jdk-slim

# 2. Set environment variables
ENV MAVEN_VERSION=3.9.9
ENV MYSQL_DRIVER_VERSION=8.0.33
ENV APP_HOME=/app

# 3. Set working directory
WORKDIR $APP_HOME

# 4. Install Maven and required tools
RUN apt-get update && \
    apt-get install -y wget tar && \
    wget https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    tar -xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt && \
    ln -s /opt/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/bin/mvn && \
    rm apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    apt-get clean

# 5. Install MySQL JDBC driver
RUN wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_DRIVER_VERSION}/mysql-connector-java-${MYSQL_DRIVER_VERSION}.jar -P /usr/share/java/

# 6. Copy your project files into the container
COPY . $APP_HOME

# 7. Build your Java/Maven project
RUN mvn clean package -DskipTests

# 8. Expose the application port (e.g., 8080 for Spring Boot)
EXPOSE 8080

# 9. Run the application (update the jar name as per your project)
CMD ["java", "-cp", "/usr/share/java/mysql-connector-java-8.0.33.jar:target/your-app.jar", "com.example.YourMainClass"]
