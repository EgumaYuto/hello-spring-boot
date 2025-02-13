buildscript {
    dependencies {
        classpath("org.flywaydb:flyway-mysql:11.3.1")
    }
}

plugins {
    kotlin("jvm") version "1.9.21"
    kotlin("plugin.spring") version "1.9.21"
    id("org.springframework.boot") version "3.4.2"
    id("io.spring.dependency-management") version "1.1.4"
    id("org.flywaydb.flyway") version "11.3.1"
}

group = "org.example"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter")
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.jetbrains.kotlin:kotlin-reflect")
    implementation("org.jetbrains.kotlin:kotlin-stdlib")

    runtimeOnly("mysql:mysql-connector-java:8.0.33")

    testImplementation("org.jetbrains.kotlin:kotlin-test")
}

flyway {
    url = "jdbc:mysql://127.0.0.1:3306/hellodb?useSSL=false"
    user = "hellouser"
    password = "hellopassword"
}

tasks.test {
    useJUnitPlatform()
}
kotlin {
    jvmToolchain(17)
}