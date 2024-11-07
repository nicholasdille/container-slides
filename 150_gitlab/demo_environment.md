## Hands-on environment

Your personal login data:

```plaintext
code;hostname;username;password
ABCDE;seatN.inmylab.de;seat;0123456789abcdef0123456789abcdef
```

Login to VM using password:

```bash
ssh seat@seatN.inmylab.de
```

Test that it is working correctly:

```bash
docker version
```