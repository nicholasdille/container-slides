## Data Exchange
<!-- .slide: id="copy" -->

Copy file from container:

```bash
docker cp web2:/usr/share/nginx/html/index.html .
```

Copy file into container:

```bash
docker cp index.html web2:/usr/share/nginx/html
```

Test updated file:

```bash
curl http://localhost
```

### Little known fact

Copy uses tar internally:

```bash
docker cp web2:/usr/share/nginx/html - | tar -tv
```
