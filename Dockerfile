FROM public.ecr.aws/docker/library/alpine:3.23 AS base

FROM base AS build
WORKDIR /src
RUN apk add --no-cache build-base pkgconf cargo

COPY Cargo.lock Cargo.toml ./
COPY src/ ./src
RUN cargo build --release --no-default-features

FROM base AS runtime
RUN apk add --no-cache ca-certificates libgcc

COPY --from=build --chmod=755 /src/target/release/presence-for-plex /app/

ENV XDG_CONFIG_HOME=/config XDG_RUNTIME_DIR=/var/run
VOLUME /config
CMD ["/app/presence-for-plex"]
