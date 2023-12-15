FROM alpine:latest

# Read the release version from the build args
ARG RELEASE_TAG
ARG BUILD_DATE
LABEL build="JusteReseau - Version: ${RELEASE_TAG}"
LABEL description="This is a docker image for Jackett, that work with Kubernetes security baselines."
LABEL maintainer="JusteSonic"

WORKDIR /tmp

# Do the package update and install
RUN apk update && apk upgrade && \
  apk add --no-cache icu-libs libstdc++ && \
  rm -rf /var/cache/apk/*

# Install Jackett
RUN wget -O /tmp/jacket.tar.gz https://github.com/Jackett/Jackett/releases/download/${RELEASE_TAG}/Jackett.Binaries.LinuxMuslAMDx64.tar.gz \
  && tar -xvzf /tmp/jacket.tar.gz -C /opt \
  && rm -rf /tmp/*

WORKDIR /config

# Ensure the jackett user and group exists and set the permissions
RUN adduser -D -u 1000 -h /config jackett \
  && chown -R jackett:jackett /config \
  && chown -R jackett:jackett /opt/Jackett

# Set the user
USER jackett

# Expose the port
EXPOSE 9117

# Change the config directory
ENV XDG_CONFIG_HOME=/config

# Set the command
CMD ["/opt/Jackett/jackett"]
