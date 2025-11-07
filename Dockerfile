# 1. Use a stable OpenJDK image
FROM eclipse-temurin:17-jdk

# 2. Set environment variables
ENV MAVEN_VERSION=3.9.9
ENV MYSQL_DRIVER_VERSION=8.0.33
ENV APP_HOME=/app

# 3. Set working directory
WORKDIR $APP_HOME

# 4. Install Maven and required tools
RUN apt-get update && \
    apt-get install -y wget tar && \
    wget https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    tar -xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt && \
    ln -s /opt/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/bin/mvn && \
    rm apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 5. Install MySQL JDBC driver (✅ updated artifact path)
RUN wget https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/${MYSQL_DRIVER_VERSION}/mysql-connector-j-${MYSQL_DRIVER_VERSION}.jar -P /usr/share/java/

# 6. Copy your project files
COPY . $APP_HOME

# 7. Build your project
RUN mvn clean package -DskipTests

# 8. Expose the application port
EXPOSE 8080

# 9. Run your app (auto-detect JAR name)
CMD ["sh", "-c", "java -jar target/*.jar"]
