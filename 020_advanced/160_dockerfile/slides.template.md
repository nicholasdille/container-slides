## Container with build tooling 1/

All developers shoulduse the correct/same build tooling

### Separate dependency download

Add dependency file explicitly

Code changes will not effect download

```Dockerfile
FROM golang AS base
COPY go.* .
RUN go mod download

FROM base AS build
#...
```

--

## Container with build tooling 2/

All developers should use the correct/same build tooling

### Ignore the container image

Build targets are used for tasks

XXX

--

## Container with build tooling 3/

All developers shoulduse the correct/same build tooling

### Mount instead of copy

XXX

```Dockerfile
FROM base AS build
RUN --mount=target=. \\
    go build .
```

--

## Container with build tooling 4/

All developers shoulduse the correct/same build tooling

### XXX build targets

XXX

--

## Container with build tooling 5/5

All developers shoulduse the correct/same build tooling

### XXX Makefile

XXX

```Makefile
bin/example:
	@docker build . --target bin --output bin

.PHONY: unit-test
unit-test:
	@docker build . --target unit-test

.PHONY: lint
lint:
	@docker build . --target lint
```
