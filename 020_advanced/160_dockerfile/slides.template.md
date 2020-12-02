<!-- .slide: class="center" style="text-align: center; vertical-align: middle" -->

## Optimizing a Dockerfile

---

## Optimizing a Dockerfile

### Order

Order by rate of change

From low frequency of change at the top

To high frequency of change at the bottom

### Consider

OS packages

Language dependencies

Code and other files

--

## Optimizing a Dockerfile

### Reusability

Create base image

Derive specialized images

### Example

Base image with OS packages

Derived image with language dependencies

Derived image with code

--

## Optimizing a Dockerfile

### Separation

One image for build environment

Another image for runtime environment

### Consider

Build environment will be large

Runtime environment should be small

--

## Optimizing a Dockerfile

### Parallelization

Create stages for independent steps

Fan-in

### Example

Prepare base image

Install tools in parallel

Merge in final image

--

## Optimizing a Dockerfile

### Isolation

Use image build for isolation

Write build output to host

https://github.com/chris-crone/containerized-go-dev

--

## Container with build tooling 1/5

All developers should use the correct/same build tooling

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

## Container with build tooling 2/5

All developers should use the correct/same build tooling

### Ignore the container image

Building an image is a non-goal

`Dockerfile` as declarative description of build process

--

## Container with build tooling 3/5

All developers should use the correct/same build tooling

### Mount instead of copy

No need for duplication

Use the same sources

```Dockerfile
FROM base AS build
RUN --mount=target=. \
    go build .
```

--

## Container with build tooling 4/5

All developers should use the correct/same build tooling

### Tasks as build targets

Define targets for...

Build

Test

Lint

etc.

--

## Container with build tooling 5/5

All developers should use the correct/same build tooling

### Abstraction

Build targets can be used in Makefile (or similar)

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
