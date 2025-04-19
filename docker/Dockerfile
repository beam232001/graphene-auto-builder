FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl git python3 python-is-python3 openjdk-17-jdk \
    build-essential repo unzip zip \
    ca-certificates wget sudo rsync gnupg

# Add user to match GitHub runner
RUN useradd -m builder && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER builder
WORKDIR /home/builder

ENTRYPOINT [\"/bin/bash\"]
