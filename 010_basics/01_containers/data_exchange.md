## Data Exchange

XXX

```bash
docker cp CONTAINER:/path/file .
docker cp /path/file CONTAINER:/path/file
```

XXX

```bash
docker cp CONTAINER:/path/file - | tar -xv
```

XXX

```bash
docker exec -i CONTAINER tar -C /path -c . | tar -xv
```
