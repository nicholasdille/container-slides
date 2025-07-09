FROM golang:1.24 AS build
WORKDIR /go/src/gitlab.com/nicholasdille/cc22_container_image_build_optimization
COPY go.* .
RUN go mod download
COPY . .
RUN go build -o hello .
RUN cp hello /

FROM ubuntu:24.04 AS step4
COPY --from=build /hello /usr/local/bin/
RUN apt-get update \
 && apt-get -y install --no-install-recommends \
        curl \
        ca-certificates \
        jq