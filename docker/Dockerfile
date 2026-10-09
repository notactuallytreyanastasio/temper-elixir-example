# The toolchain: Elixir and Erlang/OTP, and a Temper CLI that knows
# `-b elixir`, built from source at a pinned commit of the be-elixir work.

ARG TEMPER_REPO=https://github.com/notactuallytreyanastasio/temper.git
# the fork's main: be-elixir, typespecs checked by Dialyzer, the review's fixes
ARG TEMPER_REF=07eec83c3403ddfcd6b8db063c29951bea452d38

FROM eclipse-temurin:21-jdk AS temper
ARG TEMPER_REPO
ARG TEMPER_REF
# Temper's Gradle build looks for Python and Node while configuring its
# other backends, even to build only the CLI
RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates \
    python3 python3-venv nodejs npm \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /src/temper
RUN git init -q && git fetch -q --depth 1 "$TEMPER_REPO" "$TEMPER_REF" && git checkout -q FETCH_HEAD
# Temper's Gradle build wants a 4 GB heap
RUN ./gradlew --no-daemon -q :cli:installDist

FROM elixir:1.18
# node and npm, so `make run BACKEND=js` can run the same Temper as JavaScript
RUN apt-get update && apt-get install -y --no-install-recommends nodejs npm \
    && rm -rf /var/lib/apt/lists/*
COPY --from=temper /opt/java/openjdk /opt/java/openjdk
COPY --from=temper /src/temper/cli/build/install/temper /opt/temper
ENV JAVA_HOME=/opt/java/openjdk \
    PATH=/opt/temper/bin:/opt/java/openjdk/bin:$PATH \
    MIX_HOME=/opt/mix \
    HEX_HOME=/opt/hex
RUN mix local.hex --force && mix local.rebar --force && mix archive.install hex phx_new --force
WORKDIR /work
