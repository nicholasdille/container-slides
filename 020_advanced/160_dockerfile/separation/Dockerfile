FROM ubuntu AS base
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

FROM ubuntu
COPY --from=builder /src/hello /
ENTRYPOINT [ "/hello" ]