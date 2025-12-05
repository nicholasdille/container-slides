FROM ubuntu:24.04 AS base
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
        golang \
        ca-certificates

FROM base AS builder
WORKDIR /src
COPY go.* .
RUN go mod download
COPY . .
RUN go build -o hello .

FROM ubuntu:24.04
COPY --from=builder /src/hello /
ENTRYPOINT [ "/hello" ]