## Transition to BuildKit

Sometime it is desirable to change context and Dockerfile

What you are doing today

```plaintext
$ docker build          \\
>     --file Dockerfile \\
>     .
```

How to do this using BuildKit

```plaintext
$ buildctl build               \\
>     --frontend dockerfile.v0 \\
>     --local dockerfile=.     \\
>     --local context=.
```

Remember: Context is the path which is packed and sent to the daemon

--

## Transition to BuildKit

Publish an image in a registry

Docker has taught us to build and push container images:

```plaintext
docker build \\
    --tag my_image_name \\
    .
docker push my_image_name
```

BuildKit can directly upload to an image registry:

```plaintext
buildctl build \\
    --frontend dockerfile.v0 \\
    --local dockerfile=. \\
    --local context=. \\
    --output type=image,name=my_image_name,push=true
```

Read more about [pushing to image registries](https://github.com/moby/buildkit#imageregistry)

--

## Transition to BuildKit

Pass build arguments to customize the image build

The Docker way

```plaintext
docker build \\
    --build-arg name=value \\
    .
```

The BuildKit way

```plaintext
buildctl build \\
    --frontend dockerfile.v0 \\
    --local dockerfile=. \\
    --local context=. \\
    --opt build-arg:name=value
```

--

## Transition to BuildKit

Use an existing image as build cache

Docker is able to use an local image

```plaintext
docker build \\
    --cache-from my_image_name \\
    --tag my_image_name \\
    .
```

BuildKit can use an image in a registry...

...and download helpful layers

```plaintext
buildctl build \\
    --frontend dockerfile.v0 \\
    --local dockerfile=. \\
    --local context=. \\
    --output type=image,name=my_image_name,push=true \\
    --export-cache type=inline \\
    --import-cache type=registry,ref=my_image_name
```
