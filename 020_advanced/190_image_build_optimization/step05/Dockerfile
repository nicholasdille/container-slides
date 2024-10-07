FROM golang:1.23 AS build
WORKDIR /go/src/gitlab.com/nicholasdille/cc22_container_image_build_optimization
COPY . .
RUN go build -o hello .
RUN cp hello /

FROM scratch
COPY --from=build /hello /usr/local/bin/