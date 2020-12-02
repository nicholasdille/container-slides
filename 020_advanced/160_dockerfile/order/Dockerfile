FROM ubuntu

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
        golang \
        ca-certificates

WORKDIR /src
COPY go.* . #package.json, gemfile, pom.xml
RUN go mod download

COPY . .
RUN go build -o hello . \
 && cp hello /

ENTRYPOINT [ "/hello" ]