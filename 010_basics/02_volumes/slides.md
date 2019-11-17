## Storage

By default, processes only get locally persistent storage

Why should containers work differently?

Containers are even worse by default

--

## Non-persistent data

Enter container:

```bash
docker run -it ubuntu
```

Inside container:

```bash
touch /file.txt
ls -l /
exit
```

Look for file in new instance:

```bash
docker run -it ubuntu
```

It's gone!

--

## Locally persistent storage

Enter container with bind mount:

```bash
docker run -it -v /source:/source ubuntu
```

Create file:

```bash
touch /file
ls –l /
exit
```

Look for file in new instance:

```bash
docker run -it -v /source:/source ubuntu
```

It's alive!

--

## Persistent storage

Hard problem for green field

NFS shares are a good option

Docker storage plugins connect to storage backends
