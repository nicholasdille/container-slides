## Registry HA

Docker registry is able to use shared storage

Multiple instances can use the same storage volume

Multiple backends are supported, e.g. Amazon S3

### Start single instance

Emulate using volume for all instances:

```bash
# Start registry
docker-compose up -d
```

--

## Demo: Registry HA

Basic testing:

```bash
# Check availability of registry API
curl http://localhost:5000/v2/_catalog

# Push image and check catalog
docker pull alpine
docker tag alpine:latest localhost:5000/alpine:latest
docker push localhost:5000/alpine:latest
curl http://localhost:5000/v2/_catalog
```

--

## Demo: Registry HA

Scale-out with random ports:

```bash
# Scale registry
docker-compose up -d --scale registry=2

# Test registry nodes
curl http://localhost:32768/v2/_catalog
curl http://localhost:32769/v2/_catalog
docker pull ubuntu
docker tag ubuntu localhost:32768/ubuntu
docker push localhost:32768/ubuntu
curl http://localhost:32768/v2/_catalog
curl http://localhost:32769/v2/_catalog
```

--

## Demo: Registry HA

Test concurrency:

```bash
docker pull centos
docker tag centos localhost:32768/centos

# Upload to both registries at the same tme
cat >test.sh <<EOF
#!/bin/bash
docker push localhost:32768/centos &
docker push localhost:32769/centos &
EOF
bash test.sh

# Check contents
curl http://localhost:32768/v2/_catalog
curl http://localhost:32769/v2/_catalog
```
