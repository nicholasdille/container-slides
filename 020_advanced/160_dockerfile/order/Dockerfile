FROM ubuntu

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
        golang \
        ca-certificates

WORKDIR /src
COPY . .

RUN go mod download
RUN go build -o hello . \
 && cp hello /

ENTRYPOINT [ "/hello" ]