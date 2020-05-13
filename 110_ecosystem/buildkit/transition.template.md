## Transition to BuildKit

Sometime it is desirable to change context and Dockerfile

```plaintext
$ docker build          \\    $ buildctl build               \\
>                       \\    >     --frontend dockerfile.v0 \\
>     --file Dockerfile \\    >     --local dockerfile=.     \\
>     .                      >     --local context=.
```

XXX

Remember: Context is the path which is packed and sent to the daemon

--

## Transition to BuildKit

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

XXX https://github.com/moby/buildkit#imageregistry

--

## Transition to BuildKit

XXX build arguments

```plaintext
docker build \\
    --build-arg name=value \\
    .
```

```plaintext
buildctl build \\
    --frontend dockerfile.v0 \\
    --local dockerfile=. \\
    --local context=. \\
    --opt build-arg:name=value
```

--

## Transition to BuildKit

XXX cache

```plaintext
buildctl build \\
    --frontend dockerfile.v0 \\
    --local dockerfile=. \\
    --local context=. \\
    --output type=image,name=my_image_name,push=true \\
    --export-cache type=inline \\
    --import-cache type=registry,ref=my_image_name
```
