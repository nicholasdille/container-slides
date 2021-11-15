FROM golang:1.17 AS build
WORKDIR /go/src/gitlab.com/nicholasdille/cc21_container_image_build_optimization
COPY go.* .
RUN go mod download
COPY . .
RUN go build -o hello .
RUN cp hello /

FROM scratch
COPY --from=build /hello /usr/local/bin/