FROM golang:1.17 AS build
WORKDIR /go/src/gitlab.com/nicholasdille/cc21_container_image_build_optimization
COPY . .
RUN go build -o hello .
RUN cp hello /

FROM ubuntu:20.04
COPY --from=build /hello /usr/local/bin/