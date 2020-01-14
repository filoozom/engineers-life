# Build container
FROM openjdk:alpine AS builder

# Configuration
ARG URL=https://media.forgecdn.net/files/2849/693/EL-Serverpack-1.7.zip

RUN apk add --no-cache wget unzip && \
    # Download the pack
    wget -qO data.zip $URL && \
    unzip data.zip && \
    rm data.zip && \
    mv EL-Serverpack-* /minecraft && \
    cd /minecraft && \
    # Accept EULA
    echo "# EULA accepted on $(date)" > eula.txt && \
    echo "eula=TRUE" >> eula.txt && \
    # Remove useless files
    rm LaunchServer.* README-howto.txt


# Result container
FROM openjdk:alpine
MAINTAINER Philippe Schommers <philippe@schommers.be>
WORKDIR /minecraft

# Customisable environment variables
ENV MIN_RAM="1024M" \
    MAX_RAM="4096M" \
    JAVA_PARAMETERS="-XX:MaxPermSize=256M"

# Copy the data from the build container
COPY --from=builder /minecraft .

# Create normal user
ARG USER_UID="567"
ARG USER_GID="567"

RUN addgroup -S -g $USER_GID minecraft && \
    adduser -S -u $USER_UID -G minecraft minecraft && \
    chown -R minecraft: .

# General
USER minecraft
EXPOSE 25565

# Startup script
CMD java -Xms${MIN_RAM} -Xmx${MAX_RAM} ${JAVA_PARAMETERS} -jar forge-*-universal.jar nogui
