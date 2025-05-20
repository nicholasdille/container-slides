FROM golang:1.24 AS build
WORKDIR /go/src/gitlab.com/nicholasdille/cc22_container_image_build_optimization
COPY . .
RUN go build -o hello .
RUN cp hello /

FROM ubuntu:24.04
COPY --from=build /hello /usr/local/bin/