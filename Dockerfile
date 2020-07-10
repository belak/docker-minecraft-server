FROM openjdk:8u252-jre-buster

ARG RCON_CLI_VERSION=1.4.8
ARG MC_MONITOR_VERSION=0.1.7

RUN groupadd -r -g 1000 minecraft && useradd -d /data -g 1000 -u 1000 -r minecraft

RUN apt-get update && apt-get install -y \
    curl \
    jq \
    sudo \
  && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://github.com/itzg/rcon-cli/releases/download/${RCON_CLI_VERSION}/rcon-cli_${RCON_CLI_VERSION}_linux_amd64.tar.gz \
    | tar -xzf - -C /usr/local/bin rcon-cli
RUN curl -fsSL https://github.com/itzg/mc-monitor/releases/download/${MC_MONITOR_VERSION}/mc-monitor_${MC_MONITOR_VERSION}_linux_amd64.tar.gz \
    | tar -xzf - -C /usr/local/bin mc-monitor

RUN mkdir /usr/local/lib/mc
ADD ./scripts/* /usr/local/lib/mc/

VOLUME /data
WORKDIR /data

EXPOSE 25565

CMD ["/usr/local/lib/mc/start.sh"]

HEALTHCHECK --start-period=1m CMD mc-monitor status --host localhost --port 25565
