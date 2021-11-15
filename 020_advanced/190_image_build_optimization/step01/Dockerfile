FROM golang:1.17 AS step1
WORKDIR /go/src/gitlab.com/nicholasdille/cc21_container_image_build_optimization
COPY . .
RUN go build -o /usr/local/bin/hello .