FROM golang:1.18 AS step1
WORKDIR /go/src/gitlab.com/nicholasdille/cc22_container_image_build_optimization
COPY . .
RUN go build -o /usr/local/bin/hello .