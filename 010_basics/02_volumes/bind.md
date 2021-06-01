## Storage

By default, processes only get locally persistent storage

Why should containers work differently?

Containers are even worse by default

### Bind mount

XXX

--

## Non-persistent data

Enter container:

```bash
docker run -it --workdir /source ubuntu
```

Inside container:

```bash
touch file.txt
ls -l
exit
```

Look for file in new instance:

```bash
docker run -it --workdir /source ubuntu
```

It's gone!

--

## Locally persistent storage

Enter container with bind mount:

```bash
docker run -it --volume $PWD:/source --workdir /source ubuntu
```

Create file:

```bash
touch file.txt
ls –l
exit
```

Look for file in new instance:

```bash
docker run -it --volume $PWD:/source --workdir /source ubuntu
```

It's alive!

--

## Persistent storage

Hard problem for green field

NFS shares are a good option

Docker storage plugins connect to storage backends
