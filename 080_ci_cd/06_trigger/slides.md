## Trigger

Extends example for fan-in

1. Obtain token from drone
1. Add secret `downstream_token` with token to the following repositories:
    - base
    - backend
    - frontend
1. Update `.drone.yml` in the following repositories:
    - base
    - backend
    - frontend
1. Check triggered pipelines
