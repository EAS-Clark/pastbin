# Stage 1: Base image with necessary tools for downloading and extracting JDKs
FROM ubuntu:latest AS base

RUN apt-get update && apt-get install -y wget tar

# Stage 2: Build image for Java 8
FROM base AS java8

WORKDIR /usr/lib/jvm
RUN wget -q https://download.java.net/java/GA/jdk8/212/GPL/openjdk-8u212-b03-linux-x64.tar.gz && \
    tar -xzf openjdk-8u212-b03-linux-x64.tar.gz && \
    rm openjdk-8u212-b03-linux-x64.tar.gz

# Stage 3: Build image for Java 11
FROM base AS java11

WORKDIR /usr/lib/jvm
RUN wget -q https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz && \
    tar -xzf openjdk-11.0.2_linux-x64_bin.tar.gz && \
    rm openjdk-11.0.2_linux-x64_bin.tar.gz

# Stage 4: Build image for Java 17
FROM base AS java17

WORKDIR /usr/lib/jvm
RUN wget -q https://download.java.net/java/early_access/jdk17/33/GPL/openjdk-17-ea+33_linux-x64_bin.tar.gz && \
    tar -xzf openjdk-17-ea+33_linux-x64_bin.tar.gz && \
    rm openjdk-17-ea+33_linux-x64_bin.tar.gz

# Stage 5: Final image
FROM ubuntu:latest

# Copy JDKs from previous stages
COPY --from=java8 /usr/lib/jvm/jdk1.8.0_212 /usr/lib/jvm/java8
COPY --from=java11 /usr/lib/jvm/jdk-11.0.2 /usr/lib/jvm/java11
COPY --from=java17 /usr/lib/jvm/jdk-17 /usr/lib/jvm/java17

# Set default JAVA_HOME and PATH
ENV JAVA_HOME /usr/lib/jvm/java11
ENV PATH $JAVA_HOME/bin:$PATH

# Add a script to switch between Java versions
COPY switch-java.sh /usr/local/bin/switch-java.sh
RUN chmod +x /usr/local/bin/switch-java.sh
