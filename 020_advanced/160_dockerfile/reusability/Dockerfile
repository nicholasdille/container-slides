FROM ubuntu AS base
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
        golang \
        ca-certificates

FROM base AS deps
WORKDIR /src
COPY go.* .
RUN go mod download

FROM deps AS builder
COPY . .
RUN go build -o hello . \
 && cp hello /
ENTRYPOINT [ "/hello" ]